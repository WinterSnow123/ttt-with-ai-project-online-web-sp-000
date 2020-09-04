require 'pry'
module Players
  class Computer < Player

    attr_accessor :game


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

def defense_play?
  defense_plays = []
  WIN_COMBINATIONS.each do |combo|
      token_count = 0
      opponent_token_count = 0
      blank_count = 0
    combo.each do |index|
      if @board.cells[index] == @token
        token_count += 1
      elsif @board.cells[index] == @opponent_token
        opponent_token_count += 1
      else
        blank_count += 1
      end
    end
    if opponent_token_count == 2 && blank_count == 1
      defense_plays << combo
    end
  end
  defense_plays
end

def offense_play?
  offense_plays = []
  WIN_COMBINATIONS.each do |combo|
      token_count = 0
      opponent_token_count = 0
      blank_count = 0
    combo.each do |index|
      if @board.cells[index] == @token
        token_count += 1
      elsif @board.cells[index] == @opponent_token
        opponent_token_count += 1
      else
        blank_count += 1
      end
    end
    if token_count == 2 && blank_count == 1
      offense_plays << combo
    end
  end
  offense_plays
end

def compete_play?
  compete_plays_offense = []
  compete_plays_defense = []
  final_plays = []
  WIN_COMBINATIONS.each do |combo|
      token_count = 0
      opponent_token_count = 0
      blank_count = 0
    combo.each do |index|
      if @board.cells[index] == @token
        token_count += 1
      elsif @board.cells[index] == @opponent_token
        opponent_token_count += 1
      else
        blank_count += 1
      end
    end
    if token_count == 1 && blank_count == 2
      compete_plays_offense << combo
    elsif opponent_token_count == 1 && blank_count == 2
      compete_plays_defense << combo
    end
  end
  compete_plays_offense.each do |combo|
    combo.each do |index|
    compete_plays_defense.each do |com|
      if com.include?(index)
      final_plays << combo
    end
    end
  end
end
  final_plays.uniq
end


def defense_move
  if defense_play?[0] != nil
    defense_play?.sample.detect{|index| @board.cells[index] == " "}
  else
    nil
  end
end

def offense_move
  if offense_play?[0] != nil
    offense_play?.sample.detect{|index| @board.cells[index] == " "}
  else
    nil
  end
end

def compete_move
  if compete_play?[0] != nil
    final_plays = compete_play?.flatten.select do |index|
      @board.open_cells.include?(index + 1) && next_to(index, @opponent_token)[0] != nil
    end
  end
    if final_plays != nil
      final_plays.sample
    else
      nil
    end
  end

def opponent_board
  [0,1,2,3,4,5,6,7,8].select{|index| @board.cells[index] == @opponent_token}
end

def my_board
  [0,1,2,3,4,5,6,7,8].select{|index| @board.cells[index] == @token}
end


def next_to(input, char)
  case input
  when 0
    [1,3,4].select{|x| @board.cells[x] == char}
  when 1
    [0,3,4].select{|x| @board.cells[x] == char}
  when 2
    [1,4,5].select{|x| @board.cells[x] == char}
  when 3
    [0,4,6].select{|x| @board.cells[x] == char}
  when 4
    [0,1,2,3,5,6,7,8].select{|x| @board.cells[x] == char}
  when 5
    [2,4,8].select{|x| @board.cells[x] == char}
  when 6
    [3,4,7].select{|x| @board.cells[x] == char}
  when 7
    [6,4,8].select{|x| @board.cells[x] == char}
  when 8
    [4,5,7].select{|x| @board.cells[x] == char}
  end
end


def move(board)
  puts "Computer is thinking of a move..."
  case board.turn_count
  when 0
    input = [0,2,6,8].sample
    @my_last_move = input
  when 1
    if [0,2,6,8].include?(@game.last_move)
      input = 4
      @my_last_move = input
    else
      input = [0,2,6,8].sample
      @my_last_move = input
    end
  when 2
    input = @board.open_cells.select{|x| next_to(@game.last_move, " ").include?(x-1) && next_to(@my_last_move, " ").include?(x-1)}.sample
    input -= 1
  when 3..7
    if offense_move != nil
        input = offense_move
    elsif offense_move == nil && defense_move != nil
        input = defense_move
    elsif compete_move != nil && offense_move == nil && defense_move == nil
      input = compete_move
    else
      input = @board.open_cells.sample - 1
      end
when 8
  input = @board.open_cells[0] - 1
end
input += 1
input.to_s
end
end
end
