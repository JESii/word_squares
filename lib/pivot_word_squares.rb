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
    @wlptr[row].wsize = @word_list.size
    @wlptr[row].windex = 0
  end

  def select_square
    @square = Square.new(@dimension)
    puts "#{@square}"
    create_wordlist_pointer
    initialize_wordlist_pointer_row(1)
    ### Process all words for row 1 until found or exhausted
    (0..@wlsize-1).each do |wx|
      @square[1] = word = @word_list[wx]
      puts "#{@square}"
      @square.pivot_on_point(1)
      (2..@dimension).each do |i|
        @wlptr[i].wlist = get_alpha_word_list(word[i-1])
        @wlptr[i].wsize = @wlptr[i].wlist.size
        @wlptr[i].windex = 0
      end
      row = 2
      done = false

      while not done
        break if row == 1
        if @wlptr[row].windex >= @wlptr[row].wsize
          row -= 1
          next
        end
        @square[row] = @wlptr[row].wlist[@wlptr[row].windex]
        puts "in while: #{@square}/ #{@word_list[wx]}; #{@wlptr}"
        
        @wlptr[row].windex += 1
        ### Using row(1) word, see if there's a square to be found
      end

      puts "#{@word_list[wx]}; #{@wlptr}"
    end
    %w{an no}.to_s
  end

  def select_square_SAVE
    @square = Square.new(@dimension)
    wlptr = Array.new(@dimension+1)     # Don't use zero element
    (1..@dimension).each do |i|
      wlptr[i] = WlElement.new()
    end
    wlptr[1].wlist = @word_list
    wlptr[1].wsize = @word_list.size
    wlptr[1].windex = 0
    (0..@wlsize-1).each do |wx|
      row = 1
      word = @word_list[wx]
      @square[row] = @word_list[wx]
      #puts "wx: #{wx}, #{@square}"
      @square.pivot_on_point(row)
      check_square_columns = check_square_columns(row)
      next if check_square_columns == false
      (2..@dimension).each do |i|
        wlptr[i].wlist = get_alpha_word_list(word[i-1])
        wlptr[i].wsize = wlptr[i].wlist.size
        wlptr[i].windex = 0
      end
      #puts "wlptr: #{wlptr.inspect}"
      todo = true
      row = 2
      while todo
        if row == 4
          puts "\nerror: #{row}, #{@square}, #{wlptr[row]}"
          exit
        end
        begin
          @square[row] = wlptr[row].wlist[wlptr[row].windex]
          printf "\rSS(1)      : #{row}, #{@square}\033[0K"
        rescue
          puts "\nerror: #{row}, #{wlptr[row]}"
          exit
        end
        #puts "todo: #{row}, #{wlptr[row].wlist[0..3]}, #{@square.to_s}, #{row}"
        @square.pivot_on_point(row)
        check_square_columns = check_square_columns(row)
        printf "\n\rSS         : #{row}, #{@square}, #{check_square_columns}"
        break if @square.complete? && check_square_columns == true
        if check_square_columns == false
          wlptr[row].windex += 1
          #puts "SS1: #{wlptr[row].wlist[wlptr[row].windex]}"
          if wlptr[row].windex < wlptr[row].wsize
            @square[row] = wlptr[row].wlist[wlptr[row].windex]
            @square.pivot_on_point(row)
            next
          else
            @square.clear_on_pivot(row)
            wlptr[row].windex = 0
            row -= 1
            break if row == 1     # exits from while
            #@square[row] = wlptr[row].wlist[wlptr[row].windex]
            puts "\rSS-pivot : #{row}, #{@square}"
            printf "\r\033[0KSS-backtrack: #{row}, #{@square} (#{(Time.now - @start_time).to_i} seconds)"
          end #/ if wlptr[row].windex < wlptr[row].wsize
          printf "\rSS(2)      : #{row}, #{@square}"
          next
        else
          row += 1
        end #/ if check_square_columns == false
        todo = false if @square.complete? && check_square_columns == true
      end #/ while todo
      puts "\n>wend: #{row}, #{@square}; #{@square.complete?}"
      break if @square.complete?
    end #/ (0..@wlsize).each do |wx|
    return @square
  end
  def get_next_valid_word(row,wlptr)
    done = false
    while not done
      ### ??? wlptr/wlpidx will change here...
      raise "NotImplemented - get_next_valid_word()"
    end
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
