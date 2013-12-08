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
    ws = strategy.new(@dimension, @word_list)
    word_square =  ws.select_square
    word_square.to_s
  end
end
