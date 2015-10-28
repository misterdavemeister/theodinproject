class Line
  public
  attr_reader :line, :results, :COLORS
  attr_accessor :state

  def initialize(line=[["", :white]], state=nil)
    @state = state unless state.nil?
    @line = line
  end

  def display
    puts build_line(@line)
  end

  private
  WIDTH = 80
  BACKGROUND = "\e[48;5;94m"
  RESET = "\e[0m"
  COLORS = {:blue => "\e[34m", :green => "\e[32m", :gray => "\e[90m", :purple => "\e[35m", :black => "\e[30m", :yellow => "\e[33m", :white => "\e[97m", :current => "\e[32m> ", :incorrect => "\e[91mX ", :correct => "\e[32m✓ ", :almost => "\e[33m? ", :text => "\e[30m  ", :head => "\e[32m   "}

  def build_line(l)
    line_result = ""
    line_count = 0
    unless @state.nil?
      line_result << BACKGROUND
      line_result << COLORS[@state] << RESET
      line_count += 3
    end
    l.each do |line, color|
        line_result << BACKGROUND << COLORS[color] << line << "      "
        line_count += line.length + 6
    end
    line_result << RESET
    line_result << BACKGROUND
    # results #
    unless @state.nil? || @state == :head
      if @results.nil?
        @results = Game.get_results(l)
      end

      line_result << "| Results: #{COLORS[@results[0]]} #{COLORS[@results[1]]} #{COLORS[@results[2]]} #{COLORS[@results[3]]} "
      line_count += 22
    end

    # end of line #
    spaces = ((WIDTH - line_count) / 2 )
    spaces.times { line_result.insert(0, " ") }
    line_result.insert(0, BACKGROUND)
    (WIDTH - line_count - spaces).times { line_result << " "}
    line_result << RESET << "\n"
    return line_result
  end

end

class Game
  attr_reader :guess_num

  def initialize
    @guess_num = 12
  end

  def guess
    @guess_num -= 1
  end

  def <=>
    priority = {:correct => 3, :almost => 2, :incorrect => 1}
  end

  def self.get_results(line)
    return [:correct, :correct, :almost, :incorrect]
  end
end

puts `clear`
game = Game.new
space = Line.new
title = Line.new([["MASTERMIND BY DAVID COLE", :green]], :head)
guesses = Line.new([["Guesses left: #{game.guess_num}", :green]], :head)

line1 = Line.new([["@", :blue], ["@", :yellow], ["@", :black], ["@", :blue]], :current)
line2 = Line.new([["-", :black], ["@", :black], ["-", :black], ["-", :black]], :text)
line3 = Line.new([["@", :purple], ["@", :yellow], ["@", :white], ["-", :black]], :text)

#start BOARD #####
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

line1.state = :incorrect
line2.state = :current

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
