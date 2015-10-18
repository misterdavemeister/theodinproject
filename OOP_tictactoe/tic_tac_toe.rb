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
    answer = self.ai_or_2player
    game = self.heads_or_tails if answer == 1 #1 player, play with AI
    game = Game.new(nil, 1, 2)
    game unless game.nil?
  end
  
  def self.ai_or_2player
    approved = false
    while !approved
      Game.clear
      approved = true
      puts "1 player or 2 players?"
      puts "1. 1 player"
      puts "2. 2 player"
      puts
      print "selection (1 or 2): "
      selection = gets.chomp[0]
      if selection.nil?
        approved = false
      elsif selection == '1'
        1
      elsif selection == '2'
        2
      else
        approved = false
      end
    end
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
      if selection.nil? 
        approved = false
      elsif selection.match(/1|h|H/)
        game = Game.coin(1)
      elsif selection.match(/2|t|T/)
        game = Game.coin(2)
      elsif selection.match(/3|q|Q/)
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
  
  def initialize(ai, player, player2=nil)
    @board = ["", "", "", "", "", "", "", "", ""]
    @ai = Player.new(ai) unless ai == nil
    @player = Player.new(player)
    @player2 = Player.new(player2) unless player2 == nil
  end
  
  def play_round
    (1..2).each do |turn|
      if winner? 
        display_winner 
        break
      end
      if no_moves_remaining?
        display_game_over
        break
      end
      if self.player.turn == turn
        puts "Your turn, playing as \"#{self.player.piece}\"s\n\n"
        display_board
        selection = display_menu
        return if Game.game_over? 
        play(selection)
        Game.clear
      else
        puts "Computer played as \"#{self.ai.piece}\"s\n\n"
        ai_play
        display_board
        print "(press enter)"
        gets
        Game.clear
      end
    end
  end
  
  def ai_play
    approved = false
    while !approved
      selection = rand(9)
      if @board[selection].empty?
        approved = true
        @board[selection] = self.ai.piece
      end
    end
  end
  
  def play(selection)
    approved = false
    while !approved  
      if @board[selection-1].empty?
        @board[selection - 1] = @player.piece
        approved = true
      else
        Game.clear
        puts "This position has already been used. Please pick another.\n\n"
        display_board
        selection = display_menu
      end
    end
  end
  
  def winner?(ret_message=false)
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
      message = [true, "x"]
    elsif 
      b1[0] + b1[1] + b1[2] == "ooo" ||
      b1[0] + b2[0] + b3[0] == "ooo" ||
      b1[0] + b2[1] + b3[2] == "ooo" ||
      b1[1] + b2[1] + b3[1] == "ooo" ||
      b1[2] + b2[1] + b3[0] == "ooo" ||
      b1[2] + b2[2] + b3[2] == "ooo" ||
      b2[0] + b2[1] + b2[2] == "ooo" ||
      b3[0] + b3[1] + b3[2] == "ooo" 
      message = [true, "o"]
    else 
      message = [false]
    end #if
    ret_message ? message[1] : message[0]
  end #winner?
  
  def no_moves_remaining?
    empty = 0
    @board.each do |t|
      empty += 1 if t.empty?
    end
    empty > 0 ? false : true
  end
  
  ##### VIEW ##### 
  def display_board
    return if Game.game_over?
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
    return if Game.game_over?
    approved = false
    message = false
    while !approved 
      if message
         Game.clear
         puts "Selection must be a number 1 - 9 (q/Q to quit)\n\n" 
         display_board
      end
      approved, message = true, false
      puts "Choose where to put your piece"
      print "1. Top Left    | 2.  Top Middle   | 3. Top Right \n"
      print "4. Middle Left | 5.    Center     | 6. Middle Right \n"
      print "7. Bottom Left | 8. Bottom Middle | 9. Bottom Right\n"
      puts
      print "Selection: "
      selection = gets.chomp[0]
      if selection == 'q' || selection == "Q" 
        Game.game_over = true
        return
      end
      if selection.nil? || !selection.match(/[1-9]/) 
        approved, message = false, true
      end
    end
    selection.to_i
  end
  
  def display_winner
    Game.clear
    winning_piece = winner?(true)
    winner = self.player.piece == winning_piece ? "You win!" : "The computer wins!"
    print "#{winner}"
    gets
    Game.game_over = true
  end
  
  def display_game_over
    Game.clear
    print "No more moves! It's a tie!"
    gets
    Game.game_over = true
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

game = Game.start
Game.clear 
if !Game.game_over?
  puts game.player.turn == 1 ? "You won the coin toss! You have first turn." : "You lost the coin toss! You have second turn."
else
  print "Goodbye!"
end

while !Game.game_over?  
  game.play_round
  Game.clear
  print "Goodbye!" if Game.game_over?
end

