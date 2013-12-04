require 'rspec'
require 'spec_helper'

require_relative '../lib/word_squares_reader'

puts '===============WordSquaresReader==================='
describe "WordSquaresReader" do
  it "aborts with an invalid input file" do
    expect{ WordSquaresReader.new('junque') }.to raise_error    #("Invalid word file")
  end
  it "loads a word file successfully" do
    create_test_word_list(%w{a i})
    wsr = WordSquaresReader.new(TEST_FILE)
    expect(wsr.getwords(1)).to eql ['a','i']
  end
  it "load two-letter words successfully" do
    create_test_word_list(%w{as am no me})
    wsr = WordSquaresReader.new(TEST_FILE)
    expect(wsr.getwords(2)).to eql ['as', 'am', 'no', 'me']
  end
  it "loads two-letter words only" do
    create_test_word_list(%w{abc i as am mix no me a})
    wsr = WordSquaresReader.new(TEST_FILE)
    wsr.getwords(2).should =~ ['as', 'am', 'no', 'me']
  end
end
