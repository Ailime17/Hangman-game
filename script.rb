require 'yaml'

module YamlHangman
  def ask_to_open_saved_game
    while @answer2 != 'y' && @answer2 != 'n'
      puts 'Open saved game? y/n'
      @answer2 = gets.strip.downcase
    end
    return unless @answer2 == 'y'

    open_saved_game
    guess_rounds
  end

  def open_saved_game
    game_file = File.open('saved_game.yaml', 'r')
    yaml = game_file.read
    file = YAML.safe_load(yaml)#, permitted_classes: [Hangman])
    # file = YAML.safe_load(File.read('saved_game.yaml'))
    @computer = file['computer']
    @place_for_word = file['place_for_word']
    @name = file['name']
    @incorrect_letters = file['incorrect_letters']
    @remaining_guesses = file['remaining_guesses']
    @user_won = file['user_won']
  end

  def ask_to_save_game
    @answer1 = ''
    while @answer1 != 'y' && @answer1 != 'n'
      puts 'Save game? y/n'
      @answer1 = gets.strip.downcase
    end
    save_game if @answer1 == 'y'
  end

  def save_game
    yaml = YAML.dump(
      'computer' => @computer,
      'place_for_word' => @place_for_word,
      'name' => @name,
      'incorrect_letters' => @incorrect_letters,
      'remaining_guesses' => @remaining_guesses,
      'user_won' => @user_won
    )
    game_file = File.open('saved_game.yaml', 'w')
    game_file.write(yaml)
    game_file.close
  end
end

class Hangman
  include YamlHangman

  def initialize
    @answer2 = ''
    ask_to_open_saved_game if File.exist?('saved_game.yaml')
    return if @answer2 == 'y'

    print 'Enter your name to play: '
    @name = gets.strip
    puts "Hello #{@name}! Welcome to the hangman game. Try to guess the letter or the full word. You have 10 guesses."
    puts "To exit game, type 'exit'."
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
    puts "You win, #{@name}!"
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
      ask_to_save_game unless @remaining_guesses == 10
      display_word(@place_for_word)
      puts "Remaining guesses: #{@remaining_guesses}"
      puts "Incorrect letters: #{@incorrect_letters}" unless @incorrect_letters.empty?
      @remaining_guesses -= 1
      print 'Your guess: '
      user_guess = gets.strip.downcase
      break if user_guess == 'exit'

      eval_guess(user_guess)
    end
    display_end_game_message
  end

  def display_end_game_message
    return if @remaining_guesses.positive? && @user_won == false && (@answer1 == 'y' || @answer2 == 'y')

    display_word(@place_for_word) unless @place_for_word == @computer
    puts "Word to guess was: #{@computer}\nGame over"
  end
end
Hangman.new
