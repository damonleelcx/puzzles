class SortPuzzle
  def initialize(columns : Int32, capacity : Int32)
    @columns = columns
    @capacity = capacity
    @bins = Array(Array(Int32)).new(@columns) { |i| Array(Int32).new(@capacity, i + 1) }
    @bins[@columns - 1] = [] of Int32 # Last bin should be empty
  end

  def display
    print "\n"
    (0...@capacity).reverse_each do |i|
      @bins.each do |bin|
        if i < bin.size
          print "#{bin[bin.size - 1 - i]}\t"
        else
          print "\t"
        end
      end
      puts
    end

    # Print bin numbers
    @bins.each_with_index do |_, index|
      print "Bin #{index + 1}\t"
    end
    puts
  end

  def shuffle_bins
    all_elements = @bins.flatten
    all_elements.shuffle!
    @bins.each_with_index do |bin, index|
      bin.clear
      @capacity.times do
        bin << all_elements.shift unless all_elements.empty?
      end
    end
  end

  def move(move_out_bin_index : Int32, move_in_bin_index : Int32)
    move_out_bin = @bins[move_out_bin_index]
    move_in_bin = @bins[move_in_bin_index]

    return if move_out_bin.empty?

    top_element = move_out_bin.first
    elements_to_move = [] of Int32

    while !move_out_bin.empty? && move_out_bin.first == top_element
      elements_to_move << move_out_bin.shift
    end

    if move_in_bin.empty? || (move_in_bin.first == top_element && move_in_bin.size + elements_to_move.size <= @capacity)
      elements_to_move.reverse_each { |element| move_in_bin.unshift(element) }
    else
      puts "Move aborted: move-in bin would exceed capacity or top elements do not match."
      elements_to_move.reverse_each { |element| move_out_bin.unshift(element) } # Put elements back
    end
  end

  def check_win_condition
    non_empty_bins = @bins.reject { |bin| bin.empty? }
    return false if non_empty_bins.size != @columns - 1

    non_empty_bins.each do |bin|
      return false if bin.size != @capacity
      return false unless bin.uniq.size == 1
    end

    true
  end

  def play
    loop do
      display
      if check_win_condition
        display
        puts "Congratulations! You've won the game!"
        break
      end

      puts "Enter the move-out bin index (1 to #{@columns}):"
      move_out_bin_index_input = gets
      next if move_out_bin_index_input.nil? || move_out_bin_index_input.strip.empty?
      move_out_bin_index = move_out_bin_index_input.to_i - 1

      puts "Enter the move-in bin index (1 to #{@columns}):"
      move_in_bin_index_input = gets
      next if move_in_bin_index_input.nil? || move_in_bin_index_input.strip.empty?
      move_in_bin_index = move_in_bin_index_input.to_i - 1

      if move_out_bin_index >= 0 && move_out_bin_index < @columns && move_in_bin_index >= 0 && move_in_bin_index < @columns
        move(move_out_bin_index, move_in_bin_index)
      else
        puts "Invalid bin index. Please try again."
      end

      if check_win_condition
        display
        puts "Congratulations! You've won the game!"
        break
      end
    end
  end
end

# Example usage
puzzle = SortPuzzle.new(5, 3)
puzzle.shuffle_bins
puzzle.play