require 'rspec'
require 'spec_helper'
require_relative '../lib/squares'


puts '===============Squares==================='

describe Square do
  it "creates a new square" do
    s = Square.new(2)
    expect(s.class).to eql Square
    expect(s.size).to eql 2
  end
  it "adds a new word row" do
    s = Square.new(2)
    s.set_row(1,'an')
    s[2]='no'
    expect(s.get_row(1)).to eq 'an'
    expect(s[2]).to eq 'no'
  end
  it "deletes a word row" do
    s = Square.new(2)
    s[1] = 'an'
    s[2] = 'xy'
    expect(s.col(2)).to eq 'ny'
    s.delete_row(2)
    expect(s.col(2)).to eq 'n'
  end
  it "returns a column" do
    s = Square.new(2)
    s[1] = 'an'
    s[2] = 'ab'
    expect(s.col(1)).to eq 'aa'
    expect(s.col(2)).to eq 'nb'
  end
  it "assigns a row pivot" do
    s = Square.new(3)
    s[1] = 'abc'
    s.pivot_on_point(1)
    expect(s.col(1)).to eq 'abc'
  end
  it "clears a row pivot" do
    s = Square.new(3)
    s[1] = 'abc'
    s.pivot_on_point(1)
    expect(s.col(1)).to eq 'abc'
    s.clear_on_pivot(1)
    expect(s.col(1)).to eq 'a'
    expect(s.col(2)).to eq 'b'
    expect(s.col(3)).to eq 'c'
  end
  it "knows when a square is complete" do
    s = Square.new(2)
    s[1] = 'an'
    expect(s.complete?).to be_false
    s.pivot_on_point(1)
    expect(s.complete?).to be_false
    s[2] = 'no'
    expect(s.complete?).to be_true
  end
  it "can display itself with to_s" do
    s = Square.new(2)
    s[1] = 'an'
    expect(s.to_s).to eq %q{["an", "  "]}
  end
end
