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
    suits = array_to_sym(SUITS)
    values = array_to_sym(VALUES)
    suits.each do |suit|
      values.each { |value| @cards << Card.new(suit, value) }
    end
    @cards.shuffle!
  end

  def array_to_sym(array)
    array.map(&:to_sym)
  end
end
