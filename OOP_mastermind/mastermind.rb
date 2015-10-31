class Line

  def initialize(line=nil, state=nil)
    @state = state
    @results = Array.new
    4.times { @results << :line }
    @changed = true

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
  COLORS = {:blue => "\e[34m", :green => "\e[32m", :gray => "\e[90m", :purple => "\e[35m", :black => "\e[30m", :yellow => "\e[33m", :white => "\e[97m", :current => "\e[32m> ", :incorrect => "\e[91mX ", :correct => "\e[32m✓ ", :almost => "\e[33m? ", :line => "\e[30m  ", :head => "\e[32m  "}

  def build_line(l)
    @changed = false
    line_result = String.new
    line_count = 0
    unless @state.nil?
      line_result << BACKGROUND
      line_result << COLORS[@state] << RESET
      line_count += 2
    end
    l.each do |line, color|
        line_result << BACKGROUND << COLORS[color] << line << "      "
        line_count += line.length + 6
    end
    line_result << RESET
    line_result << BACKGROUND

    # results #
    if @state == :line
      23.times { line_result << " " }
      line_count += 23
    elsif @state != :head && !@state.nil?
      if @results.nil?
        @results = Game.get_results(l)
      end

      line_result << "| Results: #{COLORS[@results[0]]} #{COLORS[@results[1]]} #{COLORS[@results[2]]} #{COLORS[@results[3]]} "
      line_count += 23
    end

    # end of line #
    spaces = ((WIDTH - line_count) / 2 )
    spaces.times { line_result.insert(0, " ") }
    line_result.insert(0, BACKGROUND)
    (WIDTH - line_count - spaces).times { line_result << " "}
    line_result << RESET << "\n"
    @line_result = line_result
  end
end

class Game
  # CLASS METHODS AND VARIABLES #
  def self.get_results(line)
    priority = {:correct => 3, :almost => 2, :incorrect => 1}
    retArr = Array.new
    line.each do |line, color|
      #TODO:
      #  how many colors are in exact position
      #  how many colors are right but in wrong position
      #  how many colors are wrong
    end
    return [:line, :line, :line, :line]
  end

  # INSTANCE METHODS AND VARIABLES #
  attr_reader :guess_num

  def initialize(guess_num)
    @guess_num = guess_num
    @board = make_board(@guess_num)
  end

  def make_board(num_of_lines)
    space = Line.new
    title = Line.new([["MASTERMIND BY DAVID COLE", :green]], :head)
    guesses = Line.new([["Guesses left: #{@guess_num}", :green]], :head)
    line = Array.new
    num_of_lines.times { |n| line[n] = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line) }

    board_arr = [space, title, guesses, space]
    line.each { |l| board_arr << l << space }
    board_arr
  end

  def display_board()
    @board.each { |line| line.display }
  end

  def change_board(line_num)
    board_key = 3 # add three to "1" to get to line 4 in @board which is line1
    board_key += (line_num - 1) if line_num > 1 # compensate for the space in between each line
    line = @board[line_num + board_key]
    
    line.change {yield(line)}
  end

  def guess
    @guess_num -= 1
  end

end


puts `clear`
game    = Game.new(12)
game.display_board
game.change_board(8) { |line| line.state = :incorrect }
game.display_board

=begin
space   = Line.new
title   = Line.new([["MASTERMIND BY DAVID COLE", :green]], :head)
guesses = Line.new([["Guesses left: #{game.guess_num}", :green]], :head)

line1   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line2   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line3   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line4   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line5   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line6   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line7   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line8   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line9   = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line10  = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line11  = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)
line12  = Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line)

#start BOARD #####
lines = [space, title, guesses, space, line1, space, line2, space, line3, space, line4, space, line5, space, line6, space, line7, space, line8, space, line9, space, line10, space, line11, space, line12, space]
lines.each { |line| line.display }
line1.change { |line| line.state = :incorrect }
line2.change { |line| line.state = :current }
str = gets.chomp
puts `clear`
lines.each { |line| line.display }
p str unless str.empty?

space.display
title.display

guesses.display
space.display

line1.display
space.display

line2.display
space.display

line3.display
space.display


#end BOARD #####


puts
space.display
title.display

guesses.display
space.display

line1.display
space.display

line2.display
space.display

line3.display
space.display
=end
