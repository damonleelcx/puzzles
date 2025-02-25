require "io/console"

class MemoryGame
  def initialize(size : Int32)
    @size = size
    @board = Array(Int32?).new(size * size, nil)
    @revealed = Array(Bool).new(size * size, false)
    @cursor_row = 0
    @cursor_col = 0
    @first_selection = nil
    @second_selection = nil
    populate_board
  end

  def play
    until game_over?
      display_board
      puts "Use 'w', 's', 'a', 'd' to move, spacebar to reveal:"
      input = STDIN.gets
      next unless input
      input = input.chomp

      case input
      when "w" # Up
        @cursor_row = (@cursor_row - 1) % @size
      when "s" # Down
        @cursor_row = (@cursor_row + 1) % @size
      when "a" # Left
        @cursor_col = (@cursor_col - 1) % @size
      when "d" # Right
        @cursor_col = (@cursor_col + 1) % @size
      when " " # Spacebar
        if @first_selection.nil?
          @first_selection = [@cursor_row, @cursor_col]
          reveal(@cursor_row, @cursor_col)
        elsif @second_selection.nil?
          @second_selection = [@cursor_row, @cursor_col]
          reveal(@cursor_row, @cursor_col)
          display_board
          row1, col1 = @first_selection.not_nil!
          row2, col2 = @second_selection.not_nil!
          if @board[index(row1, col1)] == @board[index(row2, col2)]
            puts "It's a match!"
          else
            puts "Not a match."
            sleep(1) # Pause to show the second selection
            hide(row1, col1)
            hide(row2, col2)
          end
          @first_selection = nil
          @second_selection = nil
        end
      end
    end

    puts "Congratulations! You've found all the pairs."
  end

private def populate_board
    numbers = (1..(@size * @size / 2)).to_a * 2
    numbers.shuffle.each_with_index do |num, index|
      @board[index] = num
    end
  end

  def display_board
    print "\e[H\e[2J" # ANSI escape codes to clear the screen

    @size.times do |row|
      @size.times do |col|
        if @cursor_row == row && @cursor_col == col
          print "["
        else
          print " "
        end

        if @revealed[index(row, col)]
          print "#{@board[index(row, col)]}"
        else
          print "X"
        end

        if @cursor_row == row && @cursor_col == col
          print "]"
        else
          print " "
        end
      end
      puts
    end
  end

  def index(row, col)
    row * @size + col
  end

  def reveal(row, col)
    @revealed[index(row, col)] = true
  end

  def hide(row, col)
    @revealed[index(row, col)] = false
  end

  def valid_move?(row1, col1, row2, col2)
    [row1, col1, row2, col2].all? { |n| n >= 0 && n < @size } &&
      !@revealed[index(row1, col1)] && !@revealed[index(row2, col2)] &&
      !(row1 == row2 && col1 == col2)
  end

  def game_over?
    @revealed.all?
  end
end

game = MemoryGame.new(4)
game.play
