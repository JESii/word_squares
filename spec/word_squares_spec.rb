require 'rspec'
require 'spec_helper'
require_relative '../lib/word_squares'

puts '===============WordSquares==================='
describe "WordSquares" do
  context "basic functionlity" do
    it "returns an empty array for a 1-square" do
      create_test_word_list(%w{a i})
      ws = WordSquares.new(TEST_FILE)
      expect(ws.generate(1)).to eq []
    end
    it "returns a simple 2-square with only two words" do
      create_test_word_list(%w{an no})
      ws = WordSquares.new(TEST_FILE)
      expect(ws.generate(2)).to eq ['an','no']
    end
    it "returns a simple 2-square when three words" do
      create_test_word_list(%w{an ax no})
      ws = WordSquares.new(TEST_FILE)
      expect(ws.generate(2)).to eq ['an', 'no']
    end
    xit "returns a 2-square with multiple invalid combinations" do
      create_test_word_list(%w{ax az bz cz an dz xz nz no})
      ws = WordSquares.new(TEST_FILE)
      expect(ws.generate(2)).to eq ['an', 'no']
    end
  end
  context "utility functions" do
    it "selects a word on a column" do
      create_test_word_list(%w{an no})
      ws = WordSquares.new(TEST_FILE)
      ws.square = ['an', 'no']
      expect(ws.get_column_word(1)).to eql 'an'
      expect(ws.get_column_word(2)).to eql 'no'
    end
    it "checks a word/word-stem" do
      create_test_word_list(%w{an no})
      ws = WordSquares.new(TEST_FILE)
      wsr = WordSquaresReader.new(TEST_FILE)
      ws.word_list = wsr.getwords(2)
      expect(ws.check_word_stem('az')).to eql false 
    end
  end
end
