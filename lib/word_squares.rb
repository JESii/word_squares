require_relative 'word_squares_reader'
require_relative 'base_word_squares'

class WordSquares
  attr_accessor :square, :word_list

  def initialize(filename)
    @filename = filename
    @start_time = Time.now
  end

  def generate(dimension, strategy=BaseWordSquares)
    @dimension = dimension
    wsr = WordSquaresReader.new(@filename)
    return [] if @dimension == 1
    @word_stem_memo = []
    @alpha_word_list ||= {}
    @word_list = wsr.getwords(@dimension)
    #puts "#{@word_list.size} #{@dimension}-letter word list"
    ws = strategy.new(@dimension, @word_list)
    word_square =  ws.select_square
  end

  def select_square_altps
    @square = []
    wlsize = @word_list.size
    wlptr = Array.new(@dimension,0)
    wlpidx = row = 0
    todo = true
    while todo
      puts "SS-altps: #{row}, #{wlptr}[#{wlpidx}]"
      ### Must limit this to 'allowable' values
      # If it's the first row, then anything goes
      # Otherwise, it must 'match' what's already in the row
      @square[row] = get_next_valid_word(row,wlptr,wlpidx)
      check_row_column = check_row_column(row)
      puts "SS_altps: #{@square}, #{check_row_column}"
      if check_row_column == false
        wlptr[wlpidx] += 1
        if wlptr[wlpidx] >= wlsize
          wlptr[wlpidx] = 0
          delete_row_column(row)
          row -= 1
          return [] if row == -1
          wlpidx -= 1
          wlptr[wlpidx] += 1
          @square[row] = @word_list[wlptr[wlpidx]]
          printf "\r\033[0KSS-backtrack: #{@square}, #{row}, #{wlptr}[#{wlpidx}] (#{(Time.now - @start_time).to_i} seconds)"
        end
        next
      end
      row += 1
      wlpidx += 1
      todo = false if check_square_filled? == true && check_row_column == true
    end
    return @square
  end
  def get_next_valid_word(row,wlptr,wlpidx)
    done = false
    while not done
      ### ??? wlptr/wlpidx will change here...
    end
  end
  def check_square_filled?
    (0..@dimension-1).each do |r|
      return false if @square[r].size != @dimension
    end
    true
  end

  def check_row_column(row)
    # Propagate row to corresponding column
    # Check columns (rows) to see if valid
    propagate_row_column(row)
    return check_square_columns_altps(row)
  end
  def check_square_columns_altps(row)
    # Select each new row 'word' or partial word (word-stem)
    # Check to see if there is a word that could match that word
    # If YES, continue for all rows
    # If NO, return false
    # Else when done return true
    puts "CSC_altps: #{@square}"
    (row+1..@dimension-1).each do |r|
      word_stem = @square[r]
      word_stem_match = check_word_stem(word_stem) 
      if word_stem_match == false
        return false
      end
    end
    true
  end
  def propagate_row_column(row)
    (row+1..@dimension-1).each do |c|
      puts "PRC: row: #{row}, r: #{row}, c: #{c}"
      @square[c] ||= ''
      @square[c] << @square[row][c]
    end
  end
  def delete_row_column(row)
    (row..@dimension-1).each do |r|
      @square[r] = @square[r][0,r-1]
    end
  end


  def get_column_word(column)
    size = @square.size
    column_word = ""
    (0..size-1).each do |row|
      column_word << @square[row][column-1]
      #puts "CS: #{column_word}, #{row}, #{@square[row]}"
    end
    #puts "CS: #{column_word}"
    column_word
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
