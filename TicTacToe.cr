require "io/console"

class TicTacToe
  @@board : Array(Array(String)) = Array.new(3) { Array.new(3, " ") }
  @@current_player = "X"

  def self.display_board
    @@board.each do |row|
      puts row.join(" | ")
      puts "---------"
    end
  end

  def self.play_move(row, col)
    if @@board[row][col] == " "
      @@board[row][col] = @@current_player
      switch_player
    else
      puts "Cell already taken!"
    end
  end

  def self.switch_player
    @@current_player = @@current_player == "X" ? "O" : "X"
  end

  def self.check_winner
    # Check rows and columns
    3.times do |i|
      return @@board[i][0] if @@board[i].uniq.size == 1 && @@board[i][0] != " "
      return @@board[0][i] if @@board.map { |row| row[i] }.uniq.size == 1 && @@board[0][i] != " "
    end

    # Check diagonals
    return @@board[0][0] if [@@board[0][0], @@board[1][1], @@board[2][2]].uniq.size == 1 && @@board[0][0] != " "
    return @@board[0][2] if [@@board[0][2], @@board[1][1], @@board[2][0]].uniq.size == 1 && @@board[0][2] != " "

    nil
  end

  def self.play
    cursor_row = 1
    cursor_col = 1
    winner = nil
    until winner
      display_board_with_cursor(cursor_row, cursor_col)
      puts "Player #{@@current_player}, use 'w', 's', 'a', 'd' to move and 'space' to select."
      move = get_move
      case move
      when 'w'
        cursor_row = (cursor_row - 1) % 3
      when 's'
        cursor_row = (cursor_row + 1) % 3
      when 'a'
        cursor_col = (cursor_col - 1) % 3
      when 'd'
        cursor_col = (cursor_col + 1) % 3
      when ' '
        puts "Placing move at (#{cursor_row}, #{cursor_col})"
        play_move(cursor_row, cursor_col)
        display_board # Add this line to see the board after each move
        winner = check_winner
      end
    end
    display_board
    puts "Player #{winner} wins!"
  end

  def self.get_move
    input = nil
    until ['w', 's', 'a', 'd', ' '].includes?(input)
      input = STDIN.read_char
    end
    input
  end

  def self.display_board_with_cursor(cursor_row, cursor_col)
    @@board.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if i == cursor_row && j == cursor_col
          print "[#{cell}]"
        else
          print " #{cell} "
        end
      end
      puts
    end
  end
end

TicTacToe.play