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
    @square = []
    (0..@dimension-1).each do |row|
      @word_list.each do |word|
        @square[row] = word
        break if check_square_columns() == true 
      end
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
    (0..@dimension-1).each do |column|
      word_stem = get_column_word(column)
      puts "#{column}, #{word_stem}"
      return false if check_word_stem(word_stem) == false
    end
    true
  end

  def get_column_word(column)
    size = @square.size
    column_word = ""
    (0..size-1).each do |row|
      column_word << @square[row][column-1]
    end
    column_word
  end

  def check_word_stem(word_stem)
    size = word_stem.size
    @word_list.each do |word|
      return true if word_stem == word[1,size]
    end
    false
  end
end
