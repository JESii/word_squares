require_relative 'word_squares_reader'

class WordSquares
  attr_accessor :square, :word_list

  def initialize(filename)
    @filename = filename
  end

  def generate(dimension)
    @dimension = dimension
    wsr = WordSquaresReader.new(@filename)
    puts "#{@filename.size} words in total list"
    return [] if @dimension == 1
    @word_list = wsr.getwords(@dimension)
    puts "#{@word_list.size} #{@dimension}-letter word list"
    select_square
  end

  def select_square
    # Pick a word for the nth row
    # Check that all the columns are possible words so far
    # If YES, move on to the nth+1 row
    # if NO, get the next word for the nth row
    # If out of words for the nth row, backtrack to the n-1th row
    # If we have backtracked to the -1th row, there's no solution
    @square = []
    column_check = false
    wlsize = word_list.size
    wlptr = Array.new(@dimension,0)
    wlpidx = row = 0 
    todo = true
    while todo
      @square[row] = @word_list[wlptr[wlpidx]]
      #puts "SS: #{@square}, #{row}, #{wlptr}[#{wlpidx}]"
      column_check = check_square_columns
      if column_check == false
        wlptr[wlpidx] += 1
        if wlptr[wlpidx] >= wlsize
          wlptr[wlpidx] = 0
          @square.delete_at(row)
          row -= 1
          wlpidx -= 1
        end
        return [] if row == -1
        next
      end
      if @square.include?(nil)
        puts <<EOF
nil in @square (#{@square})
row = #{row}
wlpidx = #{wlpidx}
wlptr = #{wlptr}
EOF
      end
      #TODO: Handle case where there is no solution!
      row += 1
      wlpidx += 1
      todo = false if column_check == true && @square.size == @dimension
    end
    return @square
  end

  def check_square_columns()
    # Select each column 'word' or partial word (word-stem)
    # Check to see if there is a word that could match that word
    # If YES, continue for all columns
    # If NO, return false
    # Else when done return true
    #puts "CSC: #{@square}"
    (0..@dimension-1).each do |column|
      begin
        word_stem = get_column_word(column)
      rescue 
        puts <<EOF
Exception in get_column_word:
square =  #{@square}
column = #{column}
EOF
      end
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
