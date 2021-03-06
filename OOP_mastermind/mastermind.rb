require 'io/console'
GUESSES = 12 ## amount of guesses per game

### TERMINAL COLORS AND SIZE ###

def winsize
  IO.console.winsize
  rescue LoadError
  # This works with older Ruby, but only with systems
  # that have a tput(1) command, such as Unix clones.
  [Integer(`tput li`), Integer(`tput co`)]
end
$rows, $cols = winsize #for terminal reset at end of game

HEIGHT = (GUESSES * 2) + 10 ## terminal height
WIDTH = 73 # MINIMUM OF 73
TERMINAL_RESIZE = print "\e[8;#{HEIGHT};#{WIDTH};t"
BACKGROUND = "\e[48;5;237m"
RESET = "\e[0m"
CLEAR = print "\e[H\e[2J"
COLORS = { :blue => "\e[34m", :green => "\e[32m", :gray => "\e[90m", :purple => "\e[35m",
          :black => "\e[30m", :yellow => "\e[33m", :white => "\e[97m", :current => "\e[32m> ",
          :incorrect => "\e[91mX ", :correct => "\e[32m✓ ", :almost => "\e[33m? ", :line => "\e[30m  ",
          :head_menu => "\e[32m  ", :commit_guess => "\e[97m  " }

### LINE CLASS ###

class Line

  def initialize(line=nil, state=nil)
    @state = state
    @results = Array.new(4, :line)
    @changed = true #used to keep track of changes made to the line, if any changes are made the line must be rebuilt. otherwise the line is simply printed

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
    @changed = true
  end

  def state=(state)
    raise "No changes allowed without passing block to change method" if !@changing
    @state = state
  end

  def state
    @state
  end

  def results=(results)
    raise "No changes allowed without passing block to change method" if !@changing
    @results = results
  end

  def results
    @results
  end

  def display
    if @changed
      create_and_read
    else
      read
    end
  end

  def line
    @line
  end

  def modify(new_arr)
    raise "No changes allowed without passing block to change method" if !@changing
    @line = new_arr
  end

  def add(position, color)
    raise "No changes allowed without passing block to change method" if !@changing
    @line[position] = ["@", color]
  end

  def delete(position)
    raise "No changes allowed without passing block to change method" if !@changing
    @line[position] = ["-", :white]
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

  def build_line(line_arr)
    @changed = false
    line_result = String.new
    line_count = 0
    unless @state.nil?
      line_result << BACKGROUND
      line_result << COLORS[@state] << RESET
      line_count += 2
    end
    line_arr.each do |line, color|
      line_result << BACKGROUND << "  "
      line_result << COLORS[color] << line << "   "
      line_count += line.length + 5
    end
    line_result << RESET
    line_result << BACKGROUND

    if @state == :line
      23.times { line_result << " " }
      line_count += 23
    elsif @state != :head_menu && !@state.nil?
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

### GAME CLASS ###

class Game
  attr_reader :guess_num

  def initialize(guess_num, code=nil)
    TERMINAL_RESIZE
    @colors = [:blue, :green, :gray, :purple, :black, :yellow]
    @game_won = false
    @game_lost = false
    @game_over = false
    @initial_guess_num = guess_num #constant
    @guess_num = guess_num #changed throughout game to keep track of progress
    @board = make_board(@initial_guess_num)
    if code.nil?
      @@code = create_code
      puts @@code
    else
      @@code = code
    end
  end

  def start_round
    @guess_count_for_line = 0
    @round_over = false
    change_board(current_line) { |line| line.state = :current unless line.state == :head_menu }
    while !@round_over
      if @guess_num == 0
        toggle_lost
        @round_over = true
        show_solution
        display_board
        break
      end
      display_board
      puts
      print "Selection: "
      parse_input(gets.chomp)
    end
  end

  def game_over?
    @game_over
  end

  def game_over=(bool)
    @game_over = bool
  end

  def game_won?
    @game_won
  end

  def game_lost?
    @game_lost
  end

  private
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
    menu = Line.new([["MENU:", :white], ["1", :blue], ["2", :green], ["3", :gray], ["4", :purple], ["5", :black], ["6", :yellow], ["(d)elete", :white], ["(g)uess", :white]], :head_menu)
    border = String.new
    (WIDTH - 10).times { border += '_'}
    border_line = Line.new([[border, :black]], :head_menu)

    line = Array.new

    num_of_lines.times { |n| line << Line.new([["-", :white], ["-", :white], ["-", :white], ["-", :white]], :line) }
    board_arr = [space, title, guesses, space]
    line.each { |l| board_arr << l << space }
    board_arr << border_line << space << menu << space
    board_arr
  end

  def parse_input(input)
    input = input.strip
    if ["1", "2", "3", "4", "5", "6"].any? { |n| n == input }
      color = @colors[input.to_i - 1]
      add_to_line(color)
    elsif input.match(/d|D/)
      delete_from_line
    elsif input.match(/g|G/)
      if @guess_count_for_line < 4
        puts "Each guess requires 4 colors. You have provided #{@guess_count_for_line}."
        puts
        print "Selection: "
        parse_input(gets.chomp)
      else
        guess
        @round_over = true
      end
    elsif input.match(/q|Q/)
      @round_over = true
      @game_over = true
      CLEAR
    end
  end

  def display_board
    CLEAR
    @board.each { |line| line.display }
  end

  def guess
    change_board(current_line) do |line|
      line.state = :commit_guess
      line.results = get_results(line)
      if line.results.all? { |result| result == :correct }
        toggle_win
        line.state = :correct
        @guess_num -= 1
        change_guess_line
        change_board(current_line) { |line2| line2.state = :line unless line2.state == :head_menu}
        # ^^ so that the next line doesn't have an arrow before it ^^
      else
        @guess_num -= 1
        change_guess_line
      end
    end
    if game_won?
      show_victory
      display_board
    end
  end

  def parse_results(line_obj)
    retArr = Array.new
    line_obj.line.each do |line, color|
      retArr << color
    end
    retArr
  end

  def get_results(line)
    results = parse_results(line)
    retArr = Array.new
    @@tcode = @@code.clone
    check_for_correct(results).times { retArr << :correct }
    check_for_almost(results).times { retArr << :almost }
    check_for_incorrect(results).times { retArr << :incorrect }
    return retArr
  end

  def check_for_correct(line)
    count = 0
    delete_arr = Array.new
    line.each_with_index do |color, i|
      unless @@tcode[i][:deleted] == 1 then idx = @@tcode[i][color.to_sym] end
      if idx == i
        @@tcode[i] = {:deleted => 1}
        line[i] = nil
        count += 1
      end
    end
    count
  end

  def check_for_almost(line)
    count = 0
    delete_arr = Array.new
    line.each_with_index do |color, i|
      found = false
      @@tcode.each_with_index do |hash, idx|
        hash.each do |tcode_color, index|
          if !found
            if tcode_color == color
              found = true
              @@tcode[idx] = {:deleted => 1}
              line[i] = nil
              count += 1
            end
          end
        end
      end
    end
    count
  end

  def check_for_incorrect(line)
    count = 0
    @@tcode.each do |hash|
      hash.each do |color, position|
        if color.to_sym != :deleted
          count += 1
        end
      end
    end
    count
  end

  def toggle_win
    @game_won = true
  end

  def toggle_lost
    @game_lost = true
  end

  def show_solution
    ## played last turn, lost the game ##
    code = Array.new
    @@code.each do |hash|
      hash.each do |color, position|
        code << COLORS[color] + "     @     "
      end
    end
    line = @board[-2] #menu line
    line.change { |line| line.modify([["You Lost! The solution was:  #{code.join}", :white]]) }
  end

  def show_victory
    line = @board[-2] #menu line
    line.change { |line| line.modify([["You won with #{@guess_num} guesses left!", :white]]) }
  end

  def change_guess_line
    line = @board[2] #menu line
    line.change { |line| line.modify([["Guesses left: #{@guess_num}", :green]]) }
  end

  def change_board(line_num)
    board_key = 3 # add three to "1" to get to index 4 in @board which is line1 (two spaces, title line and "guesses left" line, then first guess line of the board)
    board_key += (line_num - 1) # compensate for the space in between each line
    line = @board[line_num + board_key] # get the line object from @board

    line.change {yield(line)}
  end

  def create_code
    code_arr = Array.new
    4.times { |n| code_arr << { @colors[rand(6)] => n } }
    code_arr
  end

  def add_to_line(color)
    if @guess_count_for_line < 4
      change_board(current_line) { |line| line.add(@guess_count_for_line, color) }
      @guess_count_for_line += 1
    else
      puts "You have already provided 4 colors. Type 'g' to commit guess, or 'd' to delete a guess"
      puts
      print "Selection: "
      parse_input(gets.chomp)
    end
  end

  def delete_from_line
    if @guess_count_for_line > 0
      @guess_count_for_line -= 1
      change_board(current_line) { |line| line.delete(@guess_count_for_line) }
    else
      puts "Nothing to delete"
      puts
      print "Selection: "
      parse_input(gets.chomp)
    end
  end
end

## starting and looping the game #
game = Game.new(GUESSES) unless $rows.nil? || $cols.nil?
while !game.game_over?
  if !game.game_won? && !game.game_lost?
    game.start_round
  else
    if game.game_won?
      game.game_over = true
    elsif game.game_lost?
      game.game_over = true
    end
  end
end
puts
print "Thanks for playing! (press enter)"
gets.chomp
print "\e[8;#{$rows};#{$cols};t\e[H\e[2J" #for terminal reset and clear
