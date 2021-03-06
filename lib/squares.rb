class Square
#TODO: Implement better default representation of Square"

  def initialize(dimension)
    @dimension = dimension
    @rows = @cols = @dimension -1
    @square = Array.new(dimension)
    (0..@rows).each do |r|
      @square[r] = " " * @dimension
    end
    @all_rows = @all_cols = (0..@rows)
  end

  def size
    @dimension
  end

  def to_s
    @square.inspect
  end

  def set_row(row,value)
    raise "Row less than one: #{row}" if row < 1
    @square[row-1] = value
  end
  alias :[]= :set_row
  def get_row(row)
    @square[row-1]
  end
  alias :row :get_row
  alias :[] :get_row

  def col(col)
    col_word = ''
    @all_rows.each do |r|
      col_word << @square[r][col-1]
    end
    col_word.rstrip
  end
  def complete?
    !@square.join('').include? ' '
  end
  def delete_row(row)
    @square[row-1] = " " * @dimension
  end
  def pivot_on_point(point)
    pt = point -1
    (point..@rows).each do |r|
      @square[r][pt] = @square[pt][r]
    end
  end
  def clear_on_pivot(point)
    pt = point - 1
    (pt..@rows).each do |r|
      (pt..@cols).each do |c|
        @square[r][c] = ' '
      end
    end
  end
end
