require 'json'

class Player

  attr_reader :name, :word, :letter

  def initialize(name)
    @name = name
    @player_choice_arr = []
  end

  def file_reader(txt)
    file = File.open(txt, 'r')
    @lines = file.readlines
  end

  def choose_word
    @word = @lines[rand(0..(@lines.length - 1))]
    choose_word if @word.length < 5 || @word.length > 12
  end

  def player_choice
    @letter = gets.chomp
    if @letter.match?(/[[:alpha:]]/) && @letter.length == 1 && !@player_choice_arr.include?(@letter)
      @player_choice_arr.push(@letter)
    else
      player_choice
    end
  end

end

samir = Player.new("Samir")
samir.file_reader("dictionary.txt")
samir.choose_word
puts "#{samir.name} #{samir.word}"
samir.player_choice
puts samir.letter