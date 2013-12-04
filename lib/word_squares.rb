require_relative 'word_squares_reader'

class WordSquares
  def initialize(dimension)
    @dimension = dimension
  end

  def generate
    wsr = WordSquaresReader.new('word_list.txt')
    return [] if @dimension == 1
    word_list = wsr.getwords(@dimension)
    [ word_list[0], word_list[1]]
  end
end
