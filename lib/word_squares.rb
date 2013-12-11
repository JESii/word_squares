require_relative 'word_squares_reader'
require_relative 'base_word_squares'
require_relative 'pivot_word_squares'

class WordSquares
  attr_accessor :square, :word_list

  def initialize(filename)
    @filename = filename
    @start_time = Time.now
  end

  def generate(dimension, strategy=BaseWordSquares)
    strategy = checked_strategy(strategy)
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

  def checked_strategy(strategy)
    case
    when strategy.nil?
      BaseWordSquares
    when strategy.class == String
      Kernel.const_get(strategy)
    when strategy == BaseWordSquares
      strategy
    when strategy == PivotWordSquares
      strategy
    else
      raise "Invalid strategy option: #{strategy}"
    end
  end
end
