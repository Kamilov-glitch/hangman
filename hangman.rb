require 'json'

class Player

  attr_reader :name, :word, :letter

  def initialize(name)
    @name = name
    @player_choice_arr = []
    @correct_guesses = []
    @wrong_guesses = 0
  end

  def file_reader(txt)
    file = File.open(txt, 'r')
    @lines = file.readlines
  end

  def choose_word
    @word = @lines[rand(0..(@lines.length - 1))].chomp
    choose_word if @word.length < 5 || @word.length > 12
  end

  def player_choice
    @letter = gets.chomp
    if @letter.match?(/[[:alpha:]]/) && @letter.length == 1 && !@player_choice_arr.include?(@letter)
      @player_choice_arr.push(@letter)
      if @word.split("").include?(@letter)
        @correct_guesses.push(@letter)
      else
        @wrong_guesses += 1
      end 
    else
      player_choice
    end
  end

  def display
    @word.split("").each do |l|
      if @correct_guesses.include?(l)
        print l
      else
        print ' _ '
      end
    end
  end

end

samir = Player.new("Samir")
samir.file_reader("dictionary.txt")
samir.choose_word
p "#{samir.name} #{samir.word} #{samir.word.length}"
samir.player_choice
p samir.letter
samir.display