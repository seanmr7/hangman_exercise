# Create savable hangman game
require 'yaml'

# Hangman game class
class HangmanGame
  attr_accessor :incorrect_letters, :guesses, :word, :letter_guess, :save_game_track, :board
  def initialize
    @incorrect_letters = []
    @guesses = 12
    @word = ''
    @letter_guess = ''
    @save_game_track = ''
  end

  def play_hangman
    welcome_statement
    while @guesses.positive?
      if @save_game_track == 'save game'
        save_game
        break
      end
      display
      guess
      check_guess
      break unless @board.include?('_')
    end
    p @board
    gameover_statement
  end

  def welcome_statement
    puts 'Welcome to Hangman'
    print 'Please enter your name: '
    @name = gets.chomp.capitalize
    puts 'Would you like to load a game?'
    answer = gets.chomp
    if answer == 'Y' || answer == 'y'
      load_game
    else
      select_word
      initialize_board
    end
  end

  def guess
    puts 'Would you like to save your game? Y/N?'
    answer = gets.chomp
    if answer == 'Y' || answer == 'y'
      @save_game_track = 'save game'
    else
      puts 'Select a letter'
      @letter_guess = gets.chomp.downcase
    end
  end

  private

  def save_game
    filename = "#{@name}_game"
    File.open(filename, 'w') do |file|
      file.puts YAML::dump(self)
    end
  end

  def load_game
    saved_game = File.open("#{@name}_game", 'r')
    yaml = YAML::load(saved_game)
    @incorrect_letters = yaml.incorrect_letters
    @guesses = yaml.guesses
    @word = yaml.word
    @board = yaml.board
    @save_game_track = ''
  end

  def select_word
    word_list = []
    File.readlines('5desk.txt').each do |line|
      word_list << line.chomp.downcase
    end
    @word = word_list.sample until @word.length >= 5 && @word.length <= 12
    @word = 'mishu is great!' if @name == 'Mishu'
    @word = @word.split('')
  end

  def initialize_board
    @board = Array.new(@word.length) { '_' }
  end

  def display
    puts "You have #{@guesses} guesses remaining"
    p @board
    puts "Already guessed: #{@incorrect_letters}"
  end

  def check_guess
    if @word.include?(@letter_guess)
      @word.each_with_index do |letter, idx|
        @board[idx] = letter if letter == @letter_guess
      end
      @board
    else
      if @save_game_track == 'save game'
        return
      else
        @incorrect_letters << @letter_guess
        @guesses -= 1
      end
    end
  end

  def gameover_statement
    @word = @word.join
    if @guesses.zero?
      puts 'Out of guesses'
      puts "The word was #{@word}"
    elsif @board.include?('_') == false
      puts 'You got it!'
      puts "The word was #{@word}"
    else
      puts 'Game saved. See you soon!'
    end
  end
end

game = HangmanGame.new

game.play_hangman
