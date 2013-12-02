require 'rspec'
require_relative '../lib/word_squares_reader'

describe "WordSquaresReader" do
  it "loads a word file successfully" do
    wsr = WordSquaresReader.new('one_letter_words.txt')
    expect(wsr.getwords(1)).to eql ['a','i']
  end
end
