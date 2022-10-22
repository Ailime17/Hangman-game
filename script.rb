def computer_choice
  words = File.read('10000.txt').split
  word = ''
  until word.length.between?(5, 12)
    word_index = rand(9894)
    word = words[word_index]
  end
  puts word
end
computer_choice

