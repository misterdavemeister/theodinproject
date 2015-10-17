require_relative 'tic_tac_toe'

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