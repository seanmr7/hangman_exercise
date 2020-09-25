# Create savable hangman game
require 'json'

# Hangman game class
class HangmanGame
  def initialize
    @incorrect_letters = []
    @guesses = 2
    @word = ''
  end

  def select_word
    word_list = []
    File.readlines('5desk.txt').each do |line|
      word_list << line.chomp.downcase
    end
    @word = word_list.sample until @word.length >= 5 && @word.length <= 12
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

  def guess
    puts 'Select a letter'
    @guess = gets.chomp.downcase
  end

  def check_guess
    if @word.include?(@guess)
      @word.each_with_index do |letter, idx|
        @board[idx] = letter if letter == @guess
      end
      @board
    else
      @incorrect_letters << @guess
      @guesses -= 1
    end
  end

  def gameover_statement
    @word = @word.join
    if @guesses.zero?
      puts 'Out of guesses'
    else
      puts 'You got it!'
    end
    puts "The word was #{@word}"
  end

  def play_hangman
    p select_word
    initialize_board
    while @guesses.positive?
      display
      guess
      check_guess
      break unless @board.include?('_')
    end
    p @board
    gameover_statement
  end
end

game = HangmanGame.new
game.play_hangman
