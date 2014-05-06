# Hints:
# 1. Think of the data structure required to keep track of cards in a deck.
# 2. You'll need to look up and use a "while" loop, since there could be an indeterminate number of "hits" by both the player and dealer. "while" loops are used when we don't have a finite number of iterations.
# 3. Code something. Get started, even if it's just capturing the player's name. Give it an honest attempt before looking at solutions.
# 4. Use methods to extract the piece of functionality that calculates the total, since we need it throughout the program.

# Bonus:
# 1. Save the player's name, and use it throughout the app.
# 2. Ask the player if he wants to play again, rather than just exiting.
# 3. Save not just the card value, but also the suit.
# 4. Use multiple decks to prevent against card counting players.
require "pry"
  nums = ["Ace","Two", "Three" , "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
  suits = ["Spades", "Hearts", "Diamonds", "Clubs"]
  deck = suits.product nums
  deck.shuffle!

def giving_card(name, deck)
  card =  deck.pop
  puts "#{name} are given a #{card[0] + " "+ card[1]}"
  card
end

def points_calculate cards
  cards_num = {Ace: [1,11], Two: 2, Three: 3, Four: 4, Five: 5, Six: 6, Seven: 7, Eight: 8, Nine: 9, Ten: 10, Jack: 10, Queen: 10, King: 10}
  total_value = 0
  cards.each  do |word|
     # binding.pry
      total_value += cards_num[word[1].to_sym] if word[1] != "Ace"
  end
  cards.each  do |word|
    if word =='Ace' && total_value > 10
      total_value += cards_num[word[1].to_sym][0]
    elsif word =='Ace'
      total_value += cards_num[word[1].to_sym][1]
    end
  end
  total_value
end
#Game Start
puts "I am the dealer. May I know your name?"
player_name = gets.chomp
begin
  puts "Alright. #{player_name} The Blackjack game start now."
  puts "\n"
  player_cards_held =[]
  dealer_cards_held =[]
  player_cards_held << ( giving_card player_name, deck )
  dealer_cards_held << ( giving_card "dealer", deck )
  player_cards_held << ( giving_card player_name, deck )
  dealer_cards_held << ( giving_card "dealer", deck )
  player_scores = points_calculate player_cards_held
  dealer_scores = points_calculate dealer_cards_held

  # Player turn
  if player_scores ==21
    puts "You hit blackjack. You win! "
    break
  end

  begin
    puts "Hit or Stay?"
    action = gets.chomp
    if action == "Hit"
      player_cards_held << ( giving_card player_name, deck )
      player_scores = points_calculate player_cards_held
      if (player_scores) == 21
        puts "#{player_name} got a blackjack. You win! "
        break
      elsif (player_scores) > 21
        puts "You are busted"
        puts (player_scores)
        break
      end
    elsif action == "Stay"
      break
    else
        puts "I dont understand. You can only choose  \"Hit\" or \"Stay\""
        next
    end
  end while player_scores < 21

#dealer turn
  if dealer_scores ==21
    puts "I hit blackjack. You loss!  "
    break
  end


    puts "\n"
    puts "Now it is my turn"
    while dealer_scores < 17
      dealer_cards_held << ( giving_card "dealer", deck )
      dealer_scores = points_calculate dealer_cards_held
      if (dealer_scores) == 21
        break
      elsif (dealer_scores) > 21
        puts "I am busted. You win. "
        puts (dealer_scores)
        break
      end
    end

  #Compare hands

  puts "your hands: "
  player_cards_held.each do |card|
    puts "=> #{card}"
  end
  puts "dealer hands: "
  dealer_cards_held.each do |card|
    puts "=> #{card}"
  end
  puts" You points is #{player_scores} and my points is #{dealer_scores}"
  if dealer_scores > player_scores
    puts "I win!!!!"
  elsif dealer_scores < player_scores
    puts "You win!"
  else
    puts "Draw!"
  end

  begin
    puts "Do you want to play again? Yes or No"
    response = gets.chomp
  end while (response != "Yes" && response != "No")
end while response == "Yes"







