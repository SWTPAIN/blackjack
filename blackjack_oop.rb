# Assigment: Extract Nouns and Verbs

# Write out the requirements of the blackjack game, and extract the major nouns.
#  Use those nouns to then think about abstracting behaviors into Classes. Just use a pen or text editor for this exercise; no coding yet.
#When the game start, player and dealer w
require 'pry'
class Card
  attr_accessor :suit, :value

  def initialize s,v
    @suit = s
    @value = v
  end

  def to_s
    "#{@suit} #{@value}"
  end

  def pretty_output
    "The #{@value} of #{find_suit}"
  end

  def find_suit
    case @suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end

end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      %w(1 2 3 4 5 6 7 8 9 10).each do |value|
        @cards << Card.new(suit, value)
      end
    end
      shuffle!
  end

  def shuffle!
    @cards.shuffle!
  end

  def deal_one
    @cards.pop
  end

end

module Hand
  def total
    @cards.inject(0) do |total, card|
      if card.value =='A'
        total += 11
      else
        total += ( card.value.to_i == 0 ? 10 : card.value.to_i )
      end

      @cards.select { |e| e=="A"}.count.times do
        total -= 10 if total >21
      end
    total
  end

  end

  def show_hand
    puts "----#{name}'s hands----"
    cards.each {|card| puts card.pretty_output}
  end

  def add_one new_card
    cards << new_card
  end

  def is_busted?
    total > 21 ? true : false
  end
end

class Player
  include Hand
  attr_accessor :name, :cards
  attr_reader :number_played

  def initialize name
    @name = name
    @number_played = 0
    @cards = []
  end

end

class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = 'Dealer'
    @cards = []
  end

  def show_hand
    puts "----#{name}'s hands----"
    puts "The first card is hidden"
    puts "The second one is #{cards[1].pretty_output}"
  end

end

class Blackjack
  attr_accessor :player, :deck, :dealer
  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17
  def initialize
    @player = Player.new('Player')
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def set_player_name
    puts "What is your name?"
    player.name = gets.chomp
  end

  def deal_cards
    2.times {player.add_one(deck.deal_one) ;dealer.add_one(deck.deal_one)}
  end

  def blackjack_or_busted? (player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a? Dealer
        puts "The dealer hit blackjack. #{player.name} loses"
      else
        puts "Congrats! You hit blackjack and win! "
      end
      play_again?
    elsif player_or_dealer.total > 21
      if player_or_dealer.is_a? Dealer
        puts "Congrats! The dealer is busted. You win"
      else
        puts "You are busted. The dealer win"
      end
      play_again?
    end
  end

  def play_again?
    puts "Do you want to play again? Yes or No"
    response = gets.chomp
    if response == "Yes"
      puts "Starting a new game"
      @deck = Deck.new
      @player = Player.new player.name
      @dealer = Dealer.new
      run
    elsif response == "No"
      puts "Goodbye"
      exit
    else
      puts "You can only choose Yes or No"
      play_again?
    end
  end

  def show_hand
    player.show_hand
    dealer.show_hand
  end


  def player_turn
    while ! blackjack_or_busted? (player)
      puts "Hit or Stay?"
      response = gets.chomp
      if response == 'Hit'
        new_card = @deck.deal_one
        puts "Dealing card to #{player.name}: #{new_card}"
        player.add_one (new_card)
        puts "#{player.name}'s total is now :#{player.total}"
      elsif response == 'Stay'
        break
      else
        puts "You can only choose Hit or Stay"
        next
      end
    end
  end

  def dealer_turn
    puts "Dealer's turn"
    while ! blackjack_or_busted? (dealer)
      if dealer.total < DEALER_HIT_MIN
        new_card = @deck.deal_one
        puts "Dealing card to #{dealer.name}: #{new_card}"
        dealer.add_one (new_card)
        puts "#{dealer.name}'s total is now :#{dealer.total}"
      else
        break
      end
    end
  end

  def who_win?
    if player.total > dealer.total
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} loses"
    else
      puts "It is a a tie"
    end
    play_again?
  end

  def run
    set_player_name
    deal_cards
    show_hand
    player_turn
    dealer_turn
    who_win?
  end

end


x=Blackjack.new
x.run
