class NumberPuzzle
  property grid : Array(Array(Int32))
  property move_count : Int32

  def initialize(rows : Int32, columns : Int32)
    @rows = rows
    @columns = columns
    @grid = generate_puzzle(rows, columns)
    @move_count = 0
  end

  def display
    @grid.each do |row|
      puts row.map { |num| num == 0 ? "   " : num.to_s.rjust(3) }.join(" ")
    end
    puts "Moves: #{@move_count}"
  end

  def listen_for_input
    puts "\nUse WASD keys and press Enter for movement, Q to quit:"
    while (input = gets)
      case input.strip.downcase
      when "q"
        break
      when "w", "s", "a", "d"
        solve(input.strip.downcase)
      end
      display
      if solved?
        puts "Congratulations! You've solved the puzzle in #{@move_count} moves!"
        break
      end
    end
  end

  def solve(key : String)
    empty_row, empty_col = find_empty_space

    case key
    when "w"
      if empty_row < @rows - 1
        @grid[empty_row][empty_col] = @grid[empty_row + 1][empty_col]
        @grid[empty_row + 1][empty_col] = 0
        @move_count += 1
      end
    when "s"
      if empty_row > 0
        @grid[empty_row][empty_col] = @grid[empty_row - 1][empty_col]
        @grid[empty_row - 1][empty_col] = 0
        @move_count += 1
      end
    when "a"
      if empty_col < @columns - 1
        @grid[empty_row][empty_col] = @grid[empty_row][empty_col + 1]
        @grid[empty_row][empty_col + 1] = 0
        @move_count += 1
      end
    when "d"
      if empty_col > 0
        @grid[empty_row][empty_col] = @grid[empty_row][empty_col - 1]
        @grid[empty_row][empty_col - 1] = 0
        @move_count += 1
      end
    end
  end

  private def find_empty_space : Tuple(Int32, Int32)
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |num, col_index|
        return {row_index, col_index} if num == 0
      end
    end
    raise "No empty space found in the grid"
  end

  private def generate_puzzle(rows : Int32, columns : Int32) : Array(Array(Int32))
    total_cells = rows * columns
    numbers = (1..(total_cells - 1)).to_a + [0]
    numbers.shuffle!

    Array.new(rows) do |_|
      Array.new(columns) { numbers.shift }
    end
  end

  private def solved? : Bool
    expected = 1
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |num, col_index|
        return true if row_index == @rows - 1 && col_index == @columns - 1 && num == 0
        return false if num != expected
        expected += 1
      end
    end
    false
  end
end

puzzle = NumberPuzzle.new(3, 3)
puzzle.display
puzzle.listen_for_input