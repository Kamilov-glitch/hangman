require 'json'

class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
end

class Serialization

  def save(name, word, player_choice_arr, correct_guesses, wrong_guesses)
    to_serialize = ({
      name: name,
      word: word,
      player_choice_arr: player_choice_arr,
      correct_guesses: correct_guesses,
      wrong_guesses: wrong_guesses
    })
    File.open('save_file.json', 'w+') do |f|  
      JSON.dump(to_serialize, f)  
    end  
  end

  def deserialize(str)
    JSON.parse(str)
  end


  def load(name, word, player_choice_arr, correct_guesses, wrong_guesses)
    json_file = File.read('save_file.json')
    json_file.kind_of?(String)
    loaded_data = deserialize(json_file)
    @name = loaded_data['name']
    @word = loaded_data['word']
    @player_choice_arr = loaded_data['player_choice_arr']
    @correct_guesses = loaded_data['correct_guesses']
    @wrong_guesses = loaded_data['wrong_guesses']
  end

end

class Player < Serialization

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

  #Below method chooses a random word from given dictionary that is opened by the method above(file_reader)
  def choose_word
    @word = @lines[rand(0..(@lines.length - 1))].chomp
    choose_word if @word.length < 5 || @word.length > 12
  end

  def player_choice
    @letter = gets.chomp.downcase
    if @letter.match?(/[[:alpha:]]/) && @letter.length == 1 && !@player_choice_arr.include?(@letter)
      @player_choice_arr.push(@letter)
      if @word.split("").include?(@letter)
        puts "Correctamento, mi amigo!!!".green
        @correct_guesses.push(@letter)
      else
        puts "No correctamento, try again.".red
        @wrong_guesses += 1
      end
    elsif @letter == 'save'
      save(@name, @word, @player_choice_arr, @correct_guesses, @wrong_guesses)
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
    unless 8 - @wrong_guesses == 1
      puts "You have #{8 - @wrong_guesses} attempts."
    else
      puts "You have 1 attempt left. Do your best!"
    end
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

  def start_of_game
    puts "Welcome to the hangman game, you know the rules so do I. Let's start!"
    puts "Press and enter 1 to play a new game, 2 to load a save file."
    answer = gets.chomp
    if answer == '1'
      choose_word
    elsif answer == '2'
      load(@name, @word, @player_choice_arr, @correct_guesses, @wrong_guesses)
    else
      puts "Enter 1 or 2"
      start_of_game
    end
  end

  def game
    file_reader("dictionary.txt")
    start_of_game
    puts "You can enter 'save' at any point duing game, this will save your progress."
    while true
      display
      player_choice
      if @word.split("").all?{ |e| @correct_guesses.include?(e)}
        puts "You win! Congratulations!"
        break
      elsif @wrong_guesses == 8
        puts "You're out of guesses. You lose..."
        puts "The word you had to guess was - #{@word.green}."
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
samir.game