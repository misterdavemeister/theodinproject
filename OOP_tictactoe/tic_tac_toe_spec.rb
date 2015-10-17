require 'tic_tac_toe'

describe Game do
  before(:all) do
    $game = Game.new(1, 2) #ai first, player second
  end
  
  it "initializes game" do
    expect($game.instance_of?(Game)).to eq(true)
  end
  
  it "creates a board (array) of 9 empty strings" do 
    expect($game.board).to eq(['', '', '', '', '', '', '', '', ''])
  end
  
  it "creates an ai player" do
    expect($game.instance_variable_defined?(:@ai)).to eq(true)
  end
  
  it "creates a human player" do
    expect($game.instance_variable_defined?(:@player)).to eq(true)
  end
  
  it "starts AI with xs" do
    expect($game.ai.piece).to eq("x")
  end
  
  it "starts human player with os" do
    expect($game.player.piece).to eq("o")
  end
  
  it "can draw the board" do
    $game.board = ['', '', '', '', '', '', '', '', '']
    expect($game.display)
    puts
    $game.board = ['o', 'o', 'o', 'x', 'x', 'x', 'o', 'x', 'o']
    expect($game.display)
    $game.board = ['', 'o', '', 'x', 'x', '', 'o', '', 'o']
    expect($game.display_board)
  end 
end
