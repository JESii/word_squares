require 'rspec'
require_relative '../lib/word_squares'

def create_test_word_list(words)
  File.open('test_word_list', 'w') do |file|
    words.each { |w| file << w + "\n" }
  end
end

puts '===============WordSquares==================='
describe "WordSquares" do
  it "returns an empty array for a 1-square" do
    create_test_word_list(%w{a i})
    ws = WordSquares.new('test_word_list')
    expect(ws.generate(1)).to eq []
  end
  it "returns a simple 2-square" do
    create_test_word_list(%w{an no})
    ws = WordSquares.new('test_word_list')
    expect(ws.generate(2)).to eq ['an','no']
  end
end
