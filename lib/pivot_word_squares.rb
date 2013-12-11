require_relative 'word_squares_reader'
require_relative 'base_word_squares'
require_relative 'squares'

WlElement = Struct.new(:wlist, :wsize, :windex)

class PivotWordSquares

  def initialize(dimension, word_list)
    @dimension = dimension
    @word_list = word_list
    @wlsize = @word_list.size
    @alpha_word_list ||= {}
    @word_stem_memo = []
    @start_time = Time.now
  end 

  def create_wordlist_pointer
    @wlptr = Array.new(@dimension+1)     # Don't use zero element
    (1..@dimension).each do |i|
      @wlptr[i] = WlElement.new()
    end
  end
  def initialize_wordlist_pointer_row(row)
    @wlptr[row].wlist = @word_list
    @wlptr[row].wsize = @wlsize
    @wlptr[row].windex = 0
  end

  def initialize_pointer_lists(row)
    (row..@dimension).each do |i|
      @wlptr[i].wlist = get_alpha_word_list(@square[i].rstrip)
      @wlptr[i].wsize = @wlptr[i].wlist.size
      @wlptr[i].windex = 0
    end
  end
  def select_square
    @square = Square.new(@dimension)
    create_wordlist_pointer
    initialize_wordlist_pointer_row(1)
    ### Process all words for row 1 until found or exhausted
    (0..@wlsize-1).each do |wx|
      @wlptr[1].windex = wx
      @square[1] = word = @wlptr[1].wlist[wx].clone
      @square.pivot_on_point(1)
      initialize_pointer_lists(2)
      #puts "each start: #{@wlptr[1].wlist[wx]}; #{wx}, #{@square}, #{@wlptr}"
      row = 2
      done = false

      while not done
        break if row == 1
        if @wlptr[row].windex >= @wlptr[row].wsize
          @wlptr[row].windex = 0
          @square.clear_on_pivot(row)
          printf "\r\033[0KSS-backtrack: #{@square.to_s}, #{row}, #{@wlptr[row].wsize}, #{@wlptr[row].windex}, (#{(Time.now - @start_time).to_i} seconds)"
          row -= 1
          next
        end
        @square[row] = @wlptr[row].wlist[@wlptr[row].windex].clone
        @square.pivot_on_point(row)
        initialize_pointer_lists(row+1)
        check_square_columns = check_square_columns(row)
        #puts "\n>>while   : #{@wlptr[1].wlist[wx]}; #{row}, #{@square}, #{@wlptr}\n" if @square.complete?
        #puts ">>while   : #{@wlptr[1].wlist[wx]}; #{row}, #{@square}, #{@wlptr}"
        @wlptr[row].windex += 1
        if check_square_columns == false 
          next
        else
          break if @square.complete?
          row += 1
        end
        ### Using row(1) word, see if there's a square to be found
      end
      return @square.to_s if @square.complete? && check_square_columns(1) == true
      #puts "each end  : #{@word_list[wx]}; #{wx}, #{@square}, #{@wlptr}"
    end
    []
  end


  def check_square_columns(row)
    # Select each new row 'word' or partial word (word-stem)
    # Check to see if there is a word that could match that word
    # If YES, continue for all rows
    # If NO, return false
    # Else when done return true
    #puts "CSC: #{@square}"
    (row..@dimension).each do |r|
      return false if check_word_stem(@square.col(r)) == false
    end
    #puts "CSC-true: #{@square}, #{@square}, #{row}"
    true
  end

  def check_square_columns_SAVE()
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
    get_alpha_word_list(word_stem)
    #puts "CWS: #{word_stem}, #{@alpha_word_list}"
    @alpha_word_list[word_stem].each do |word|
      #puts "CWS: #{size}, #{word_stem}, #{word[0,size]}"
      return true if word_stem == word[0,size]
    end
    false
  end
  def get_alpha_word_list(word_stem)
    @alpha_word_list[word_stem] ||= @word_list.grep(/^#{word_stem}/)
  end

end
