require_relative 'card'

class Deck
  SUITS = %i(♣ ♠ ♥ ♦).freeze
  VALUES = %i(2 3 4 5 6 7 8 9 10 J Q K A).freeze

  attr_reader :cards

  def initialize
    create_deck
  end

  def issue_cards(amount)
    @cards.shift(amount)
  end

  private

  def create_deck
    @cards = []
    SUITS.each do |suit|
      VALUES.each { |value| @cards << Card.new(suit, value) }
    end
    @cards.shuffle!
  end
end
