module Displayable
  def display_welcome_message
    clear
    puts "Welcome to Twenty-One!\n\n"
    puts "Get as close to 21 as possible, but don't go over!\n\n"
    print "Press Enter to play... "
    gets
    clear
  end

  def display_dealer_hand
    puts "The dealer's cards are:"
    dealer.display_hand
  end

  def display_player_hand
    puts "Your cards are:"
    player.display_hand
  end

  def display_hands
    clear
    display_dealer_hand
    dealer.display_total
    display_player_hand
    player.display_total
  end

  def display_results
    victor = determine_victor
    if victor == :push
      puts "Your hands are equal. It's a push!\n\n"
    else
      puts "#{victor.to_s.capitalize} wins!\n\n"
    end
    sleep(2)
  end

  def display_goodbye_message
    clear
    puts "Thank you for playing Twenty-One! Goodbye!\n\n"
  end
end

module Dealable
  def initialize_deck
    new_deck = []
    Card::SUITS.each do |suit|
      Card::RANKS_N_VALUES.each do |rank, value|
        new_deck << Card.new(rank, suit, value)
      end
    end
    @deck = new_deck.shuffle
  end

  def deal_card!
    deck.pop
  end

  def display_hidden_card
    puts "The dealer's face-down card is a #{hand.last}.\n\n"
    sleep(2)
  end
end

class Participant
  TARGET_HAND_TOTAL = 21

  attr_reader :hand

  def initialize
    reset_hand
  end

  def to_s
    self.class.to_s.downcase
  end

  def reset_hand
    @hand = []
  end

  def display_hand
    puts "*" * 30
    hand.each do |card|
      puts "=> #{card}"
    end
    puts "*" * 30
  end

  def last_card_dealt
    hand.last
  end

  def display_last_card_dealt
    puts "#{last_card_dealt} is dealt to #{self.class.to_s.downcase}\n\n"
    sleep(0.75)
  end

  def ace?
    hand.any?(&:ace?)
  end

  def hand_total
    total = hand.map(&:value).sum
    # automatically adjust for an ace
    total += 10 if ace? && total <= 11
    total
  end

  def bust?
    hand_total > TARGET_HAND_TOTAL
  end
end

class Player < Participant
  def hit?
    print "Would you like to hit, or stay? (h or s): "
    response = nil
    loop do
      response = gets.chomp.strip.downcase
      break if %w(h s).include?(response)
      puts "Not valid. Please enter h or s"
    end

    response == 'h'
  end

  def display_total
    puts "Your total is #{hand_total}\n\n"
  end

  def display_turn_results
    if hand_total == TARGET_HAND_TOTAL
      puts "You automatically stay at #{TARGET_HAND_TOTAL}.\n\n"
    elsif bust?
      puts "You busted with #{hand_total}! Dealer wins!\n\n"
    else
      puts "You chose to stay at #{hand_total}.\n\n"
    end
    sleep(2)
  end
end

class Dealer < Participant
  SOFT_TARGET = 17

  include Dealable

  attr_reader :deck
  attr_writer :turn

  def initialize
    super
    initialize_deck
    @turn = false
  end

  def turn?
    @turn
  end

  def display_hand
    if turn?
      super
    else
      puts "*" * 30
      puts "=> #{hand.first}"
      puts "=> face-down card"
      puts "*" * 30
    end
  end

  def display_turn_results
    if (SOFT_TARGET..TARGET_HAND_TOTAL).cover?(hand_total)
      puts "Dealer automatically stays at #{hand_total}.\n\n"
    else
      puts "Dealer busts with #{hand_total}! You win!\n\n"
    end
    sleep(2)
  end

  def display_total
    if turn?
      puts "The dealer's total is #{hand_total}\n\n"
    else
      # adjust if shown card is an ace
      total = hand.first.ace? ? 11 : hand.first.value
      puts "The dealer's shown total is #{total}\n\n"
    end
  end

  def display_last_card_dealt
    # show card only if dealer's first card or dealer's turn
    if turn? || hand.size == 1
      super
    else
      puts "face-down card is dealt to dealer\n\n"
      sleep(2)
    end
  end
end

class Card
  RANKS_N_VALUES = {
    ace: 1, two: 2, three: 3, four: 4, five: 5,
    six: 6, seven: 7, eight: 8, nine: 9, ten: 10,
    jack: 10, queen: 10, king: 10
  }
  SUITS = [:hearts, :spades, :diamonds, :clubs]

  attr_reader :rank, :suit, :value

  def initialize(rank, suit, value)
    @rank = rank
    @suit = suit
    @value = value
  end

  def ace?
    rank == :ace
  end

  private

  def to_s
    "#{rank} of #{suit}"
  end
end

class TwentyOneGame
  private

  attr_reader :dealer, :player

  include Displayable

  def initialize
    @dealer = Dealer.new
    @player = Player.new
  end

  def clear
    system('clear')
  end

  def give_player_card!
    player.hand << dealer.deal_card!
    player.display_last_card_dealt
  end

  def give_dealer_card!
    dealer.hand << dealer.deal_card!
    dealer.display_last_card_dealt
  end

  def deal_initial_cards!
    puts "The dealer is dealing...\n\n"
    sleep(1)
    give_player_card!
    give_dealer_card!
    give_player_card!
    give_dealer_card!
  end

  def player_turn
    loop do
      break if player.hand_total >= Participant::TARGET_HAND_TOTAL ||
               !player.hit?

      give_player_card!
      display_hands
    end

    player.display_turn_results
  end

  def dealer_turn
    dealer.turn = true
    display_hands
    dealer.display_hidden_card
    until dealer.hand_total >= Dealer::SOFT_TARGET
      give_dealer_card!
    end
    sleep(1)
    display_hands
    dealer.display_turn_results
  end

  def determine_victor
    case dealer.hand_total <=> player.hand_total
    when 0 then :push
    when 1 then dealer
    else        player
    end
  end

  def game_sequence
    deal_initial_cards!
    display_hands
    player_turn
    dealer_turn unless player.bust?
  end

  def play_again?
    response = nil
    loop do
      print "Press Enter to play again, or q to quit: "
      response = gets.chomp.strip.downcase
      break if ['', 'q'].include?(response)
      puts "Sorry, not a valid choice."
    end
    response == ''
  end

  def someone_busted?
    player.bust? || dealer.bust?
  end

  def reset
    dealer.initialize_deck
    dealer.reset_hand
    player.reset_hand
    dealer.turn = false
    clear
  end

  public

  def play
    display_welcome_message
    loop do
      game_sequence
      display_results unless someone_busted?
      break unless play_again?
      reset
    end
    display_goodbye_message
  end
end

game = TwentyOneGame.new
game.play
