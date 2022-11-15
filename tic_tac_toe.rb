module Displayable
  def display_welcome_message
    puts "Welcome to Tic Tac Toe!\n\n"
    puts "The first to #{TTTGame::WINS_PER_MATCH} wins is the Grand Winner!\n\n"
    print "Press Enter to play, or m for the settings menu: "
  end

  def display_goodbye_message
    clear
    puts "Thanks for playing Tic Tac Toe! Goodbye!\n\n"
  end

  def display_board
    display_score
    puts "#{human.name} is #{human.marker},"\
    " #{computer.name} is #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def display_score
    puts "The current score is:"
    puts "#{human.name}: #{human_wins}, #{computer.name}: #{computer_wins}.\n\n"
  end

  def display_result
    clear_screen_and_display_board

    if !board.someone_won?
      puts "Cat's game!\n\n"
    elsif grand_winner?
      puts '*' * 30
      puts "#{detect_grand_winner.name} is the Grand Winner!"
      puts '*' * 30 + "\n\n"
    else
      puts "#{detect_winner.name} is the winner!\n\n"
    end
  end

  def display_settings_menu
    clear
    puts "Settings Menu\n\n"
    puts "Choose an option to change:"
    display_name_settings
    display_marker_settings
    display_first_to_move
    puts "Press Enter to exit..."
  end

  def display_name_settings
    puts "1) human name: #{human.name}"
    puts "2) computer name: #{computer.name}"
  end

  def display_marker_settings
    puts "3) #{human.name}'s marker: #{human.marker}"
    puts "4) #{computer.name}'s marker: #{computer.marker}"
  end

  def display_first_to_move
    puts "5) First turn: #{first_to_move.name}\n\n"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_play_again_message
    puts "Let's play again!\n\n"
  end
end

class Board
  attr_reader :squares

  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9],
    [1, 4, 7], [2, 5, 8], [3, 6, 9],
    [1, 5, 9], [3, 5, 7]
  ]

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def []=(key, marker)
    squares[key].marker = marker
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].unmarked? }
  end

  def joined_unmarked_keys(delimiter: ', ', last_delimiter: 'or')
    unmarked_keys_arr = unmarked_keys
    case unmarked_keys_arr.size
    when 1
      unmarked_keys_arr.first
    when 2
      unmarked_keys_arr.join(" #{last_delimiter} ")
    else
      unmarked_keys_arr[-1] = "#{last_delimiter} #{unmarked_keys_arr.last}"
      unmarked_keys_arr.join(delimiter)
    end
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def get_line_markers(line)
    squares.values_at(*line).map(&:marker)
  end

  def winning_marker
    WINNING_LINES.each do |line|
      current_markers = get_line_markers(line)
      marker = current_markers.first
      next if marker == Square::INITIAL_MARKER
      return marker if current_markers.all?(marker)
    end
    nil
  end

  def winning_square(marker)
    WINNING_LINES.each do |line|
      current_markers = get_line_markers(line)
      if current_markers.include?(Square::INITIAL_MARKER) &&
         current_markers.count(marker) == 2
        return line.find { |key| squares[key].marker == Square::INITIAL_MARKER }
      end
    end
    nil
  end

  def winning_square?(marker)
    !!winning_square(marker)
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker: INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  WINS_PER_MATCH = 3
  @@human_wins = 0
  @@computer_wins = 0

  private

  include Displayable
  attr_reader :board, :human, :computer
  attr_accessor :current_player, :first_to_move

  def human_wins
    @@human_wins
  end

  def computer_wins
    @@computer_wins
  end

  def initialize
    @board = Board.new
    @human = Player.new('Human', HUMAN_MARKER)
    @computer = Player.new('Computer', COMPUTER_MARKER)
    @first_to_move = human
    @current_player = first_to_move
  end

  def welcome_sequence
    display_welcome_message
    response = nil
    loop do
      response = gets.chomp.downcase.strip
      break if ['', ' ', 'm'].include?(response)
      puts "Sorry, not a valid choice."
      print "Press Enter to play, or enter m for the menu: "
    end
    change_setting if response == 'm'
    clear
  end

  def choose_first_player?
    puts "If you don't decide who goes first, #{computer.name} will.\n\n"
    print "Would you like to decide who goes first? (y or n): "
    response = nil
    loop do
      response = gets.chomp.downcase.strip
      break if %w(y n yes no).include?(response)
      print "Sorry, not a valid choice. Please choose y or n: "
    end

    %w(y yes).include?(response)
  end

  def human_sets_first_player
    clear
    self.first_to_move = choose_first_player
    self.current_player = first_to_move
  end

  def choose_first_player
    print "Okay, who goes first?"\
    " (1 for #{human.name}, 2 for #{computer.name}): "
    response = nil
    loop do
      response = gets.chomp.strip
      break if %w(1 2).include?(response)
      print "Sorry, not a valid choice. Please enter 1 or 2: "
    end

    response == '1' ? human : computer
  end

  def set_first_player
    clear
    if choose_first_player?
      human_sets_first_player
    else
      self.first_to_move = [human, computer].sample
      puts "Okay, #{computer.name} has decided"\
      " that #{first_to_move.name} goes first."
      sleep(2)
      self.current_player = first_to_move
    end
  end

  def human_chooses_setting
    display_settings_menu
    response = nil
    loop do
      response = gets.chomp.strip
      break if ['1', '2', '3', '4', '5', ''].include?(response)
      puts "Sorry, not a valid choice. Please choose an option (1-5)."
    end
    response
  end

  def human_changes_a_name(player)
    clear
    print "Enter a new name for #{player.name}: "
    response = nil
    loop do
      response = gets.chomp.strip.capitalize
      break unless ['', ' '].include?(response)
      print "Sorry, must enter a name: "
    end
    player.name = response
  end

  def human_changes_a_marker(player)
    clear
    print "Enter a single character for #{player.name}'s new marker: "
    player.marker = choose_new_marker(player)
  end

  def choose_new_marker(player)
    response = nil
    loop do
      response = gets.chomp.strip
      break if valid_marker?(player, response)
      puts "Sorry, must enter a single character that is not a space,"
      print "and is not #{other_player_marker(player)}"\
      " (#{other_player(player).name}'s marker): "
    end

    response
  end

  def valid_marker?(player, new_marker)
    new_marker.size == 1 && new_marker != other_player_marker(player) &&
      new_marker != Square::INITIAL_MARKER
  end

  def other_player(player)
    player == human ? computer : human
  end

  def other_player_marker(player)
    other_player(player).marker
  end

  def change_setting
    loop do
      case human_chooses_setting
      when '1' then human_changes_a_name(human)
      when '2' then human_changes_a_name(computer)
      when '3' then human_changes_a_marker(human)
      when '4' then human_changes_a_marker(computer)
      when '5' then set_first_player
      else          break
      end
    end
  end

  def human_moves
    square = nil
    loop do
      print "Choose a square (#{board.joined_unmarked_keys}): "
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice.\n\n"
    end

    board[square] = human.marker
  end

  def able_to_win?
    board.winning_square?(computer.marker)
  end

  def at_risk?
    board.winning_square?(human.marker)
  end

  def take_the_win
    key = board.winning_square(computer.marker)
    board[key] = computer.marker
  end

  def make_defensive_move
    key = board.winning_square(human.marker)
    board[key] = computer.marker
  end

  def computer_moves
    if able_to_win?
      take_the_win
    elsif at_risk?
      make_defensive_move
    elsif board.unmarked_keys.include?(5)
      board[5] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      self.current_player = computer
    else
      computer_moves
      self.current_player = human
    end
  end

  def player_move
    loop do
      current_player_moves
      increment_score
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def human_turn?
    current_player == human
  end

  def detect_winner
    board.winning_marker == human.marker ? human : computer
  end

  def increment_score
    return unless board.someone_won?
    if detect_winner == human
      @@human_wins += 1
    else
      @@computer_wins += 1
    end
  end

  def reset_score
    @@human_wins = 0
    @@computer_wins = 0
  end

  def detect_grand_winner
    return human if human_wins >= WINS_PER_MATCH
    return computer if computer_wins >= WINS_PER_MATCH
    nil
  end

  def grand_winner?
    !!detect_grand_winner
  end

  def play_again?
    print "Press Enter to play again, q to quit, or m for settings menu: "
    response = nil
    loop do
      response = gets.chomp.downcase.strip
      break if ['', ' ', 'q', 'm'].include?(response)
      print "Not valid, please enter q, m, or press Enter to play again: "
    end

    change_setting if response == 'm'
    [' ', '', 'm'].include?(response)
  end

  def clear
    system('clear')
  end

  def reset
    board.reset
    self.current_player = first_to_move
    reset_score if grand_winner?
    clear
  end

  def main_game
    loop do
      display_board
      player_move
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  public

  def play
    clear
    welcome_sequence
    main_game
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
