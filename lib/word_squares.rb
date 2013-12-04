require_relative 'word_squares_reader'

class WordSquares
  attr_accessor :square, :word_list

  def initialize(filename)
    @filename = filename
  end

  def generate(dimension)
    @dimension = dimension
    wsr = WordSquaresReader.new(@filename)
    return [] if @dimension == 1
    @word_list = wsr.getwords(@dimension)
    select_square
  end

  def select_square
    # Pick a word for the nth row
    # Check that all the columns are possible words so far
    # If YES, move on to the nth+1 row
    # if NO, get the next word for the nth row
    # If out of words for the nth row, backtrack to the n-1th row
    @square = []
    column_check = false
    (0..@dimension-2).each do |row|
      @word_list.each do |test_word|
        @square[row] = test_word
        @word_list.each do |word|
          @square[row+1] = word
          column_check = check_square_columns()
          next if column_check == false
        end
        # If we get here...
        #puts "#{@square}, #{row}, #{@dimension-1}"
        break if column_check == true && @square.size == @dimension
      end
      #return [] if column_check == false
    end
    @square
  end

  def check_square_columns()
    # Select each column 'word' (may be partial)
    # Check to see if there is a word that could match that word
    # If YES, continue for all columns
    # If NO, return false
    # Else when done return true
    return true if @square.size == 1
    #puts "CSC: #{@square}"
    (0..@dimension-1).each do |column|
      #puts "CSC: #{column}"
      word_stem = get_column_word(column)
      #puts "CSC: #{column}, #{word_stem}"
      return false if check_word_stem(word_stem) == false
    end
    true
  end

  def get_column_word(column)
    size = @square.size
    column_word = ""
    (0..size-1).each do |row|
      #puts "CS: #{row}, #{@square[row]}"
      column_word << @square[row][column-1]
    end
    #puts "CS: #{column_word}"
    column_word
  end

  def check_word_stem(word_stem)
    size = word_stem.size
    @word_list.each do |word|
      #puts "CWS: #{size}, #{word_stem}, #{word[0,size]}"
      return true if word_stem == word[0,size]
    end
    false
  end
end
