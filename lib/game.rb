require 'pry'

class Game

  attr_accessor :player_1, :player_2, :board

  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6]
  ]

  def initialize(player_1=Players::Human.new("X"),player_2=Players::Human.new("O"),board=Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  def current_player
    @board.turn_count.even? ? @player_1 : @player_2
  end

  def won?
    x_win = WIN_COMBINATIONS.detect{|combo| combo.all?{|index| @board.cells[index] == "X"}}
    x_win ? x_win : WIN_COMBINATIONS.detect{|combo| combo.all?{|index| @board.cells[index] == "O"}}
  end

  def draw?
    @board.full? && !won?
  end

  def over?
    draw? || won?
  end

  def winner
    won? ? @board.cells[won?[0]] : nil
  end

  def turn
    input = current_player.move(@board)
    @board.valid_move?(input) ? @board.update(input,current_player) : current_player.move(@board)
    @board.display
  end

  def play
    until over?
      turn
    end
    if draw?
      puts "Cat's Game!"
    else
      puts "Congratulations #{winner}!"
    end
end
end
