#wordsquares

##Description
Thoughtbot coding challenge: given a dictionary of some kind, generate 
[word squares]( http://en.wikipedia.org/wiki/Word_square "Wikipedia word square") of size n.

###Initial Approach
After some consideration, I decided to use the approach of filling the word square one word(row) at a time and testing to see if that word or (partial) combination of letters (a 'word-stem') is a valid possibility by checking the existing columns to see if there were a possible word match.

For example, for a 2-square (word square of size 2), given a dictionary containing the words 'av', 'an', 'no', we can determine that the word 'av' in the first row is invalid because there is no 2-letter word starting with 'v'. Therefore, we don't have to test any of words in line 2 and can skip to try the next word in row 1.

This started out as a straight-forward exercise, but I was unhappy with the original completion times, so I eventually coded several different strategies and refactored the program using the Strategy Pattern. At this point, there are three strategies, presented in the order that they were developed.

###Strategies

1. NaiveWordSquares - a \'brute-force\' approach, which simply tries all the possible words, one at a time. 'Possible' in this case includes consideration as to whether a word added to a row results in acceptable words for each column. If the new row word results in an unacceptable column word, that new word is skipped. This strategy also includes memoization of words that might fit into a column, given what's already in that column.
1. BaseWordSquares. This is identical to the NaiveWordSquares strategy except that it uses a separate Square class to hold the word square, rather than a simple array. This Base strategy is rather slower: a 6-square generated via the Naive strategy takes about 571 seconds, wherea the same 6-square generated via this Base strategy takes about 652 seconds, a roughly 14% decrease in performance due to the use of the Square class. The tradeoff is that the Base version is clearer and made it easier to develop the Pivot strategy.
1. PivotWordSquares - an approach which searches for 'pefect' word squares (i.e., the word in the ith row is also placed into the ith column). My research indicated that perfect word squares are quite common. In this strategy, each time I add a new word in a row 'n', I 'pivot' that word so that it also exists in column 'n'. This strategy includes similar memoization as the BaseWordSquares strategy, but this time based on what is already in the rows because of the pivoting. Thus, if the algorithm has already selected 'abacay' for row 1 and 'bacule' for row 2, then rows 3 through 6 contain ''ac', 'cu', 'al', and 'ye', respectively, and the memoization limits words selected for each row to these prefixes. This occurs as each new word is added to a row.

##Running the programs
There are two different programs. In either case, you must specify a strategy.

1. The first (word\_squares) generates word squares up to a 6x6;<br/>

    <pre>./word_squares [strategy]</pre>
1. The other (one\_word\_square) generates the desired size word square directly.<br/>

    ./one\_word\_square [size] [strategy]

If you wish to code your own runner, this will do the trick, in an executable file:

    #!/usr/bin/env ruby
    require_relative 'lib/word_squares'
    @ws = WordSquares.new([word_list], [strategy])    # There's a word list called... wait for it: word_list
    @word_square = @ws.generate([dimension])

##Results
1. First attempt simply used the basic approach with no optimization and generated a 5-square in 5650 seconds. The 6-square was still running (overnight) at 8 hours when I terminated it :=)
1. Adding memoization of the known 'bad' word-stems improved the 5-square generation to 205 seconds.
1. Additional enhancements yielded a 6-square generated in a little over 6 minutes.
1. Final implementation of the Pivot strategy resulted in a 6-square in 7.1 seconds, and a 7-square in 80 seconds.

<table border="1">
<tr>
<th>Size</th><th>Naive</th><th>Base</th><th>Pivot</th>
</tr>
<tr>
<td>5-square</td><td>7 sec</td><td>7 sec</td><td>2 sec</td>
</tr>
<tr><td>6-square</td><td>571 sec</td><td>652 sec</td><td>7 sec</td></tr>
<tr>
<td>7-square</td><td>>8 hours</td><td>>8 hours</td><td>80 sec</td>
</tr>
</table>
