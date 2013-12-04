require_relative 'word_squares_reader'

class WordSquares
  def initialize(filename)
    @filename = filename
  end

  def generate(dimension)
    @dimension = dimension
    wsr = WordSquaresReader.new(@filename)
    return [] if @dimension == 1
    word_list = wsr.getwords(@dimension)
    [ word_list[0], word_list[1]]
  end
end
