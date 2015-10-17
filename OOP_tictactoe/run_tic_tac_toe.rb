require_relative 'tic_tac_toe'

game = Game.start
Game.clear 
puts game.player.turn == 1 ? "You won the coin toss! You have first turn." : "You lost the coin toss! You have second turn."

while !Game.game_over?  
  game.play_round
end