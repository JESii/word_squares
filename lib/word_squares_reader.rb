class WordSquaresReader
  def initialize(filename)
    @filename = checked_for_input_filename(filename)
  end

  def getwords(count)
    @filename.each_line.map { |w| w.chomp.size == count ? w.chomp : nil }.compact
  end

  private

  def checked_for_input_filename(filename)
    raise "Invalid word file" if File.readable?(filename) == false
    File.open(filename)
  end
end
