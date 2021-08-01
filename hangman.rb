require 'json'

class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
end

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

  def showing_all_guesses
    @player_choice_arr.each do |e|
      if @correct_guesses.include?(e)
        print e.green
      else
        print e.red
      end
    end
    puts " "
  end

  def display
    showing_all_guesses
    @word.split("").each do |l|
      if @correct_guesses.include?(l)
        print l
      else
        print ' _ '
      end
    end
    puts " "
  end

  def game
    file_reader("dictionary.txt")
    choose_word
    p "#{@name} #{@word} #{@word.length}"
    while true
      player_choice
      p @letter
      display
      if @word.split("").all?{ |e| @correct_guesses.include?(e)}
        puts "You win! Congratulations!"
        break
      elsif @wrong_guesses == 8
        puts "You're out of guesses. You lose..."
        break
      end
    end
    replay
  end

  def replay
    @correct_guesses = []
    @wrong_guesses = 0
    @player_choice_arr = []
    puts "Do you want to play again? Enter 'y' for yes or 'n' for no: "
    answer = gets.chomp.downcase
    if answer == 'y'
      game
    elsif answer == 'n'
      puts "Nice seeing you. Have a nice day!Byeee!!!"
    else
      replay
    end
  end


end

samir = Player.new("Samir")
# samir.file_reader("dictionary.txt")
# samir.choose_word
# p "#{samir.name} #{samir.word} #{samir.word.length}"
# samir.player_choice
# p samir.letter
# samir.display
samir.game