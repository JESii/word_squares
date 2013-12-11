require_relative 'squares'

class BaseWordSquares

  def initialize(dimension,word_list)
    @dimension = dimension
    @word_list = word_list
    @alpha_word_list ||= {}
    @word_stem_memo = []
  end

  def select_square
    # Pick a word for the nth row
    # Check that all the columns are possible words so far
    # If YES, move on to the nth+1 row
    # if NO, get the next word for the nth row
    # If out of words for the nth row, backtrack to the n-1th row
    # If we have backtracked to the -1th row, there's no solution
    @start_time = Time.now
    @square = Square.new(@dimension)
    column_check = false
    wlsize = @word_list.size
    wlptr = Array.new(@dimension,0)
    wlpidx =  0 
    row = 1
    todo = true
    while todo
      @square[row] = @word_list[wlptr[wlpidx]]
      column_check = check_square_columns
      if column_check == false
        wlptr[wlpidx] += 1
        if wlptr[wlpidx] >= wlsize
          wlptr[wlpidx] = 0
          @square.delete_row(row)
          row -= 1
          return [] if row == 0
          wlpidx -= 1
          wlptr[wlpidx] += 1
          @square[row] = @word_list[wlptr[wlpidx]]
          printf "\r\033[0KSS-backtrack: #{@square.to_s}, #{row}, #{wlptr}[#{wlpidx}] (#{(Time.now - @start_time).to_i} seconds)"
        end
        next
      end
      row += 1
      wlpidx += 1
      todo = false if column_check == true && @square.complete?
    end
    #puts "BWS: #{@square.class}, #{@square}"
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
      word_stem = @square.col(column)
      #return false if @word_stem_memo.include?(word_stem)
      word_stem_match = check_word_stem(word_stem) 
      if word_stem_match == false
        #@word_stem_memo << word_stem
        return false
      end
    end
    true
  end

  def check_word_stem(word_stem)
    size = word_stem.size
    @alpha_word_list[word_stem] ||= @word_list.grep(/^#{word_stem}/)
    #puts "CWS: #{word_stem}, #{@alpha_word_list}"
    @alpha_word_list[word_stem].each do |word|
      #puts "CWS: #{size}, #{word_stem}, #{word[0,size]}"
      return true if word_stem == word[0,size]
    end
    false
  end
end
