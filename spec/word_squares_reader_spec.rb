require 'rspec'
require_relative '../lib/word_squares_reader'

puts '===============WordSquaresReader==================='
describe "WordSquaresReader" do
  it "aborts with an invalid input file" do
    expect{ WordSquaresReader.new('junque') }.to raise_error    #("Invalid word file")
  end
  it "loads a word file successfully" do
    wsr = WordSquaresReader.new('one_letter_words.txt')
    expect(wsr.getwords(1)).to eql ['a','i']
  end
  it "load two-letter words successfully" do
    wsr = WordSquaresReader.new('two_letter_words.txt')
    expect(wsr.getwords(2)).to eql ['as', 'am', 'no', 'me']
  end
  it "loads two-letter words only" do
    wsr = WordSquaresReader.new('multi_letter_words.txt')
    wsr.getwords(2).should =~ ['as', 'am', 'no', 'me']
  end
end
