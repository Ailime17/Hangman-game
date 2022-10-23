class Hangman
  def initialize(name)
    @name = name
    # puts "Hello #{@name}! Welcome to the hangman game. Try to guess the letter or the full word. You have 10 guesses"
    @computer = computer_choice
    puts @computer
    @place_for_word = '_' * @computer.length
    @remaining_guesses = 10
    @user_won = false
    @incorrect_letters = ''
    guess_rounds
  end

  def display_word(word)
    puts "Word: #{word}"
  end

  def computer_choice
    words = File.read('10000.txt').split
    word = ''
    until word.length.between?(5, 12)
      word_index = rand(9894)
      word = words[word_index]
    end
    word
  end

  def user_won
    @user_won = true
    puts 'You win!'
  end

  def swap_dashes_for_letters(the_guess)
    letter_places = []
    @computer.split('').each_with_index do |letter, index|
      letter_places.push(index) if letter == the_guess
    end
    letter_places.each do |letter_place|
      @place_for_word[letter_place] = the_guess
    end
  end

  def update_bad_letters(the_guess)
    return if @incorrect_letters.include?(the_guess)

    @incorrect_letters.insert(-1, "#{the_guess},")
  end

  def last_bad_guess?
    puts @remaining_guesses.zero? ? 'Bad guess. You lose' : 'Bad guess. Try again'
  end

  def eval_guess(guess)
    if guess.length == 1
      case @computer.include?(guess)
      when true
        puts 'Good guess!'
        swap_dashes_for_letters(guess)
        user_won if @place_for_word == @computer
      else
        last_bad_guess?
        update_bad_letters(guess)
      end
    elsif guess == @computer
      @place_for_word.replace(guess)
      user_won
    else
      last_bad_guess?
    end
  end

  def guess_rounds
    while @remaining_guesses.positive? && @user_won == false
      display_word(@place_for_word)
      puts "Remaining guesses: #{@remaining_guesses}"
      puts "Incorrect letters: #{@incorrect_letters}" unless @incorrect_letters.empty?
      @remaining_guesses -= 1
      print 'Your guess: '
      user_guess = gets.strip
      eval_guess(user_guess)
    end
    display_word(@place_for_word)
    puts "Word to guess was: #{@computer}\nGame over"
  end
end
# puts "Enter your name to play:"
# name = gets.strip
Hangman.new('e')
