module Blackjack
  BASIC_CARD_AMOUNT = 2
  BASIC_CASH = 100
  BET = 10
  MAX_CARDS = 3
  ACE_MIN = 1
  ACE_MAX = 11
  WIN_POINTS = 21

  def points(cards)
    points = 0
    aces = []
    cards.each { |card| is_ace?(card) ? aces << card : points += point(card) }
    return points if aces.empty?
    points += count_aces(points, aces)
    points
  end

  private

  def is_ace?(card)
    card.value == :A
  end

  def count_aces(points, aces)
    min = ACE_MIN
    max = ACE_MAX
    case aces.size
    when 1
      points + max <= WIN_POINTS ? max : min
    when 2
      points + max + min <= WIN_POINTS ? max + min : min + min
    when 3
      max + min + min
    end
  end

  def point(card)
    return 10 if [:K, :J, :Q].include?(card.value)
    return { min: ACE_MIN, max: ACE_MAX } if is_ace?(card)
    card.value.to_s.to_i
  end
end
