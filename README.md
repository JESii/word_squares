#wordsquares

##Description
Thoughtbot coding challenge: given a dictionary of some kind, generate 
[word squares]( http://en.wikipedia.org/wiki/Word_square "Wikipedia word square") of size n.

##Running the program
There's a word\_squares program in the root directory that will generate word squares from 2 through 6 (warning a 6-square takes a LONG time)

If you wish to run the program yourself, this will do the trick, in an executable file:

    #!/usr/bin/env ruby
    require_relative 'lib/word_squares'
    @ws = WordSquares.new(\<word_list>)    # There's a word list called... wait for it: word_list
    @word_square = @ws.generate(\<dimension>)

##Approach
After some consideration, I decided to use the approach of filling the word square one word(row) at a time and testing to see if that word or (partial) combination of letters (a 'word-stem') is a valid possibility by checking the existing columns to see if there were a possible word match.

For example, for a 2-square (word square of size 2), given a dictionary containing the words 'av', 'an', 'no', we can determine that the word 'av' in the first row is invalid because there is no 2-letter word starting with 'v'. Therefore, we don't have to test any of words in line 2 and can skip to try the next word in row 1.

##Results
1. First attempt simply used the basic approach with no optimization and generated a 5-square in 5650 seconds. The 6-square was still running (overnight) at 8 hours when I terminated it :=)
1. Adding memoization of the known 'bad' word-stems improved the 5-square generation to 205 seconds.

##Possible Improvements
1. One obvious performance gain can be had by limiting the word-stem search to words that start with the given word-stem; right now it searches all words in the list.

##Bugs
The un-memoized algorithm generated the following 5-square (which is also a perfect word square with the same words horizontally and vertically):

    a a l i i
    a b o r d
    l o b a l
    i r a d e
    i d l e r

whereas the memoized algorithm generated the following:

    a a l i i
    b e a r d
    e r b i a
    a i r a n
    m e a n t
    
