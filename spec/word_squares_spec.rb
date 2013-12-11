require 'rspec'
require 'spec_helper'
require_relative '../lib/word_squares'
require_relative '../lib/base_word_squares'
require_relative '../lib/pivot_word_squares'
require_relative '../lib/naive_word_squares'

puts '===============WordSquares==================='
describe "WordSquares" do
  [BaseWordSquares, PivotWordSquares, NaiveWordSquares].each do |strategy|
    context "[#{strategy}]" do
      it "returns an empty array for a 1-square" do
        create_test_word_list(%w{a i})
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(1,strategy)).to eq []
      end
      it "returns a simple 2-square with only two words" do
        create_test_word_list(%w{an no abc})
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(2,strategy)).to eq ['an','no'].to_s
      end
      it "returns a simple 2-square when three words" do
        create_test_word_list(%w{an ax no})
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(2,strategy)).to eq ['an', 'no'].to_s
      end
      it "returns a 2-square with multiple invalid combinations" do
        create_test_word_list(%w{ax an no})
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(2,strategy)).to eq ['an', 'no'].to_s
      end
      it "returns a simple 3-word square" do
        create_test_word_list(%w{axe bit and ice uno nod to ten doe no})
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(3,strategy)).to eq %w{bit ice ten}.to_s
      end
      it "handles case of no possible square" do
        create_test_word_list( %w{an ax to do} )
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(2,strategy)).to eql [].to_s
      end
      it "handles a back-tracking situation" do
        create_test_word_list( %w{ada axe axx non ono} )
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(3,strategy)).to eql %w{non ono non}.to_s
      end
      it "handles a simple 5-square" do
        create_test_word_list( %w{aalii abord lobal irade idler} )
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(5,strategy)).to eq %w{aalii abord lobal irade idler}.to_s
      end
      it "handles a more complex 5-square" do
        create_test_word_list( %w{broad blink large links issue agile alist aalii abord lobal irade idler} )
        ws = WordSquares.new(TEST_FILE)
        expect(ws.generate(5,strategy)).to eq %w{aalii abord lobal irade idler}.to_s
      end
    end

    ### These probably should be private methods and therefore shouldn't be spec'd
    # However, it's easier for me to test the method directly...
    context "utility functions" do
      xit "selects a word on a column" do
        create_test_word_list(%w{an no})
        ws = WordSquares.new(TEST_FILE)
        ws.square = ['x1', '2z']
        expect(ws.get_column_word(1)).to eql 'x2'
        expect(ws.get_column_word(2)).to eql '1z'
      end
      xit "rejects an invalid column word/word-stem" do
        create_test_word_list(%w{an no})
        ws = WordSquares.new(TEST_FILE)
        ws.square = %w{ax no}
        expect(ws.get_column_word(1)).to eql 'an'
        expect(ws.get_column_word(2)).to eql 'xo'
      end
      xit "checks a word/word-stem" do
        create_test_word_list(%w{an no})
        ws = WordSquares.new(TEST_FILE)
        ws.instance_variable_set(:@alpha_word_list, '{}')
        wsr = WordSquaresReader.new(TEST_FILE)
        ws.word_list = wsr.getwords(2)
        expect(ws.check_word_stem('az')).to eql false 
        expect(ws.check_word_stem('an')).to eql true
      end
      xit "checks a word/word-stem with an invalid element" do
        create_test_word_list(%w{axe and not goo})
        ws = WordSquares.new(TEST_FILE)
        wsr = WordSquaresReader.new(TEST_FILE)
        ws.word_list = wsr.getwords(2)
        expect(ws.check_word_stem('az')).to eql false 
      end
    end
  end
end
