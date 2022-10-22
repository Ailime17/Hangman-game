class Hangman
  def initialize(name)
    @name = name
    # puts "Hello #{@name}! Welcome to the hangman game. Try to guess the letter or the full word. You have 10 guesses"
    @computer = computer_choice
    @place_for_letter = ' _'
    @display = "Word:#{@place_for_letter * @computer.length}"
    puts @display
    @remaining_guesses = 10
    # puts "Remaining guesses: #{remaining_guesses}"
    guess_round
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

  def guess_round
    if @remaining_guesses.positive?
      @remaining_guesses -= 1
    else
      puts 'Game over'
      return
    end
    puts @computer
    puts 'Your guess: '
    user_guess = gets.strip
    if user_guess.length == 1 && @computer.include?(user_guess)
      puts "good job"
    elsif  user_guess == @computer
      puts 'you win'
    else
      puts "you lose"
    end
  end
end
# puts "Enter your name to play:"
# name = gets.strip
Hangman.new('e')
