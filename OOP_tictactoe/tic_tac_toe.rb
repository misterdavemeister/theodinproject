class Game
  ##### CLASS METHODS AND VARIABLES #####
  @@game_over = false
  
  def self.clear
     print "\e[H\e[2J"
  end
  
  def self.game_over? 
    @@game_over
  end
  
  def self.game_over=(bool)
    @@game_over = bool
  end
  
  ### FACTORY METHODS ###
  def self.start
    game = self.heads_or_tails
    game unless game.nil?
  end
  
  def self.heads_or_tails
    approved = false
    while !approved
      Game.clear
      approved = true
      puts "Pick heads or tails" 
      puts "1. Heads"
      puts "2. Tails"
      puts "3. Quit"
      puts
      print "selection: "
      selection = gets.chomp[0]
      if selection.match(/1|h|H/)
        game = Game.coin(1)
      elsif selection.match(/2|t|T/)
        game = Game.coin(2)
      elsif selection.match(/3|q|Q/)
        puts "GOODBYE!"
        Game.game_over = true
      else
        approved = false
      end
    end
    game unless game.nil?
  end
  
  def self.coin(coin)
    if coin == 1 + rand(2)
      game = Game.new(2, 1) #player first / toss won
    else
      game = Game.new(1, 2) #computer first / toss lost
    end
    game unless game.nil?
  end
  
  ### instance methods and variables ###
  attr_accessor :board, :ai, :player
  
  def initialize(ai, player)
    @board = ["", "", "", "", "", "", "", "", ""]
    @ai = Player.new(ai)
    @player = Player.new(player)
  end
  
  def play_round
    display_board
    display_menu
    puts "Playing round"
    gets
    Game.game_over = true
  end
  
  def winner?
    b1 = @board.slice(0, 3)
    b2 = @board.slice(3, 3)
    b3 = @board.slice(6, 3)
    if  b1[0] + b1[1] + b1[2] == "xxx" ||
        b1[0] + b2[0] + b3[0] == "xxx" ||
        b1[0] + b2[1] + b3[2] == "xxx" ||
        b1[1] + b2[1] + b3[1] == "xxx" ||
        b1[2] + b2[1] + b3[0] == "xxx" ||  
        b1[2] + b2[2] + b3[2] == "xxx" ||
        b2[0] + b2[1] + b2[2] == "xxx" ||
        b3[0] + b3[1] + b3[2] == "xxx"
      return [true, "The computer wins!"]
    elsif 
      b1[0] + b1[1] + b1[2] == "ooo" ||
      b1[0] + b2[0] + b3[0] == "ooo" ||
      b1[0] + b2[1] + b3[2] == "ooo" ||
      b1[1] + b2[1] + b3[1] == "ooo" ||
      b1[2] + b2[1] + b3[0] == "ooo" ||
      b1[2] + b2[2] + b3[2] == "ooo" ||
      b2[0] + b2[1] + b2[2] == "ooo" ||
      b3[0] + b3[1] + b3[2] == "ooo" 
      return [true, "You win!"]
    else 
      return [false]
    end #if
  end #winner?
  
  ##### VIEW ##### 
  def display_board
    puts "Playing as '#{self.player.piece}'s\n\n"
    @board.each_with_index do |piece, idx|
      if (idx + 1) % 3 != 0
        print piece.empty? ? " " : piece
        print "|"
      else 
        puts piece.empty? ? " " : piece
        puts "-----" unless idx == @board.length - 1
      end
    end
    puts
  end
  
  def display_menu
    puts "Choose where to put your piece"
    print "1. Top Left    | 2.  Top Middle   | 3. Top Right \n"
    print "4. Middle Left | 5.    Center     | 6. Middle Right \n"
    print "7. Bottom Left | 8. Bottom Middle | 9. Bottom Right\n"
    puts
    print "Selection: "
    selection = gets.chomp[0]
  end
  
  ##### PLAYER SUBCLASS #####
  private
  class Player
    attr_reader :piece, :turn
  
    def initialize(first_or_second)
      if first_or_second == 1
        @piece, @turn = "x", 1
      else 
        @piece, @turn = "o", 2
      end
    end  
  end
end

