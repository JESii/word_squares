
TEST_FILE = 'test_word_list'

def create_test_word_list(words)
  File.open(TEST_FILE, 'w') do |file|
    words.each { |w| file << w + "\n" }
  end
end

