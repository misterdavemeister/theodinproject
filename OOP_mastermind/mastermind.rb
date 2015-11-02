##### LINE CLASS #####
=begin
  This class is used
  to make objects that
  represent every line
  in the game board.
  Every line is its
  own Line instance.
=end
##### LINE CLASS #####

class Line

  def initialize(line=nil, state=nil)
    @state = state
    @guess = Array.new # used to keep track of order of colors in the guess when @state is :commit_guess
    @results = Array.new # used to keep track of results of checking guess against the computer's generated code
    4.times { @results << :line }
    @changed = true #used to keep track of changes made to the line, if any changes are made the line must be rebuilt. otherwise the line is simply rebuilt

    if line.nil?
      @line = [["", :white]]
    else
      @line = line
    end
  end

  def change
    @changing = true
    if block_given?
      yield(self)
    else
      raise "No block was given to the change method"
    end
    @changing = false
  end

  def state=(state)
    raise "No changes allowed without passing block to change method" if !@changing
    @changed = true
    @state = state
  end

  def state
    @state
  end

  def display
    if @changed
      create_and_read
    else
      read
    end
  end

  private
  @changing = false

  def create_and_read
    build_line(@line)
    puts @line_result
  end

  def read
    puts @line_result
  end

  WIDTH = 80
  BACKGROUND = "\e[48;5;94m"
  RESET = "\e[0m"
  COLORS = {:blue => "\e[34m", :green => "\e[32m", :gray => "\e[90m", :purple => "\e[35m",
            :black => "\e[30m", :yellow => "\e[33m", :white => "\e[97m", :current => "\e[32m> ",
            :incorrect => "\e[91mX ", :correct => "\e[32m✓ ", :almost => "\e[33m? ", :line => "\e[30m  ",
            :head_menu => "\e[32m  ", :commit_guess => "\e[97m  "}

  def build_line(l)
    @changed = false
    line_result = String.new
    line_count = 0
    spot_count = 0
    unless @state.nil?
      line_result << BACKGROUND
      line_result << COLORS[@state] << RESET
      line_count += 2
    end
    l.each do |line, color|
      line_result << BACKGROUND << "   "
      line_result << COLORS[color] << line << "   "
      line_count += line.length + 6
      if @state == :commit_guess
        #answer and the order of colors added to @guess
        spot_count += 1
        @guess << { color => spot_count}
      end
    end
    line_result << RESET
    line_result << BACKGROUND

    # results #
    if @state == :line
      23.times { line_result << " " }
      line_count += 23
    elsif @state != :head_menu && !@state.nil?
      @results = Game.get_results(l) if @state == :commit_guess
      line_result << "| Results: #{COLORS[@results[0]]} #{COLORS[@results[1]]} #{COLORS[@results[2]]} #{COLORS[@results[3]]} "
      line_count += 23
    end

    # end of line #
    spaces = ((WIDTH - line_count) / 2 )
    spaces.times { line_result.insert(0, " ") }
    line_result.insert(0, BACKGROUND)
    (WIDTH - line_count - spaces).times { line_result << " "}
    line_result << RESET << "\n"
    puts @guess
    @line_result = line_result
  end
end


##### GAME CLASS #####
=begin
  This class is used
  as the controller of
  the game. There is
  only one instance of
  this class. This is
  the engine that controls
  the view.
=end
##### GAME CLASS #####

class Game
  # CLASS METHODS AND VARIABLES #
  def self.get_results(line)
    #none of this is ready yet
    priority = {:correct => 3, :almost => 2, :incorrect => 1} #not sure about doing it like this
    retArr = Array.new
    line.each do |line, color|
      #TODO:
      #  how many colors are in exact position
      #  how many colors are right but in wrong position
      #  how many colors are wrong
    end
    #return [:line, :line, :line, :line]
    return [:correct, :almost, :incorrect, :incorrect]
  end

  # INSTANCE METHODS AND VARIABLES #
  attr_reader :guess_num

  def initialize(guess_num)
    @initial_guess_num = guess_num #constant
    @guess_num = guess_num #changed throughout game to keep track of progress
    @board = make_board(@initial_guess_num)
  end

  def current_line
    #to automatically pick the line to edit based on turns played =>
    #FIRST TURN: (@initial_guess_num - @guess_num) +1 => (12 - 12) + 1 => (0) + 1
    #TENTH TURN: (@initial_guess_num - @guess_num) +1 => (12 - 3) + 1 => (9) + 1
    (@initial_guess_num - @guess_num) + 1
  end

  def make_board(num_of_lines)
    space = Line.new
    title = Line.new([["MASTERMIND BY DAVID COLE", :green]], :head_menu)
    guesses = Line.new([["Guesses left: #{@guess_num}", :green]], :head_menu)
    menu = Line.new([["MENU:", :white], ["1", :blue], ["2", :green], ["3", :gray], ["4", :purple], ["5", :black], ["6", :yellow]], :head_menu)

    line = Array.new

    num_of_lines.times { |n| line << Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line) }
    board_arr = [space, title, guesses, space]
    line.each { |l| board_arr << l << space }
    board_arr << menu << space
    board_arr
  end

  def start_round
    change_board(current_line) { |line| line.state = :current}
  end

  def display_board
    @board.each { |line| line.display }
  end

  def guess
    change_board(current_line) { |line| line.state = :commit_guess }
    @guess_num -= 1
  end

  private
  def change_board(line_num)
    board_key = 3 # add three to "1" to get to line 4 in @board which is line1
    board_key += (line_num - 1) # compensate for the space in between each line
    line = @board[line_num + board_key]

    line.change {yield(line)}
  end
end


puts `clear`
game    = Game.new(12)
game.start_round
game.display_board
gets
game.guess
game.start_round
game.display_board
