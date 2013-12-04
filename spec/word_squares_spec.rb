require 'rspec'
require_relative '../lib/word_squares'

puts '===============WordSquares==================='
describe "WordSquares" do
  it "returns an empty array for a 1-square" do
    ws = WordSquares.new(1)
    expect(ws.generate).to eq []
  end
  it "returns a simple 2-square" do
    ws = WordSquares.new(2)
    expect(ws.generate).to eq ['an','no']
  end
end
