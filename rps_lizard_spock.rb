class Move
  VALUES = %w(rock paper scissors spock lizard)
  SHORTCUTS = %w(r p s v l)

  def >(other_move)
    losers.include?(other_move.class)
  end

  def to_s
    self.class.to_s.downcase
  end

  private

  attr_accessor :losers
end

class Rock < Move
  def initialize
    self.losers = [Scissors, Lizard]
  end
end

class Paper < Move
  def initialize
    self.losers = [Rock, Spock]
  end
end

class Scissors < Move
  def initialize
    self.losers = [Paper, Lizard]
  end
end

class Spock < Move
  def initialize
    self.losers = [Rock, Scissors]
  end
end

class Lizard < Move
  def initialize
    self.losers = [Paper, Spock]
  end
end

class Player
  attr_reader :name, :move

  def initialize
    set_name
    self.move_history = []
  end

  def display_history
    puts "So far, #{name} has chosen:"
    move_history.tally.each do |move, frequency|
      puts "#{move} #{frequency} #{frequency == 1 ? 'time' : 'times'}"
    end
  end

  private

  attr_writer :move, :name
  attr_accessor :move_history

  def update_move(choice)
    self.move = case choice
                when 'rock', 'r'     then Rock.new
                when 'paper', 'p'    then Paper.new
                when 'scissors', 's' then Scissors.new
                when 'spock', 'v'    then Spock.new
                when 'lizard', 'l'   then Lizard.new
                end

    update_history
  end

  def update_history
    move_history << move.to_s
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, spock, or lizard:"
      puts "You may optionally enter the first letter (v for spock)"
      choice = gets.chomp.strip.downcase
      break if valid_choice?(choice)
      puts "Sorry, invalid choice."
    end
    update_move(choice)
  end

  private

  def valid_choice?(choice)
    choices = Move::VALUES + Move::SHORTCUTS
    choices.include?(choice)
  end

  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end
end

class Computer < Player
  def choose
    update_move(Move::VALUES.sample)
  end

  private

  def set_name
    self.name = %w(R2D2 Hal Chappie Sonny Number\ 5).sample
  end
end

class Score
  attr_accessor :human, :computer

  def initialize
    self.human = 0
    self.computer = 0
  end

  def grand_winner?
    human > 4 || computer > 4
  end

  def reset
    self.human = 0
    self.computer = 0
  end
end

# Game Orchestration Engine
class RPSGame
  private

  attr_accessor :human, :computer, :score

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
  end

  def display_welcome_message
    system('clear')
    puts "Greetings #{human.name}!\n\n"
    puts "Welcome to Rock, Paper, Scissors, Spock, Lizard!\n\n"
    puts "First to 5 wins is the grand winner!\n\n"
    puts "Press Enter to play..."
    gets
    system('clear')
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Good bye!"
  end

  def display_moves
    system('clear')
    puts "#{human.name} chose #{human.move}."
    puts '----'
    puts "#{computer.name} chose #{computer.move}.\n\n"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif computer.move > human.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
    puts ''
  end

  def update_score
    if human.move > computer.move
      score.human += 1
    elsif computer.move > human.move
      score.computer += 1
    end
  end

  def display_score
    puts "The score is #{human.name}: #{score.human},"\
    " #{computer.name}: #{score.computer}.\n\n"
  end

  def display_grand_winner
    winner = score.human > score.computer ? human : computer
    puts "#{winner.name} is the grand winner!\n\n"
  end

  def display_histories
    system('clear')
    human.display_history
    puts "----"
    computer.display_history
    puts "----"
  end

  def continue_playing?
    answer = nil
    loop do
      puts "Press Enter to continue playing"\
      " (q to quit, or h to view move history)"
      answer = gets.chomp.downcase.strip
      break if ['', 'q'].include?(answer)
      next display_histories if answer == 'h'
      puts "Sorry, not a valid input."
    end

    answer == ''
  end

  def take_turns
    human.choose
    computer.choose
    update_score
  end

  def display_game_info
    display_moves
    display_winner
    display_score
  end

  def process_grand_winner
    return unless score.grand_winner?
    display_grand_winner
    score.reset
  end

  public

  def play
    display_welcome_message

    loop do
      take_turns
      display_game_info
      process_grand_winner
      break unless continue_playing?
      system('clear')
    end

    system('clear')
    display_goodbye_message
  end
end

system('clear')

RPSGame.new.play
