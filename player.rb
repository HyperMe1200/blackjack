class Player
  attr_reader :name
  attr_accessor :cash, :cards

  def initialize(name, cash)
    @name = name
    @cash = cash
  end

  def bet(amount)
    raise "Недостаточно денег у игрока #{@name}" if @cash - amount < 0
    @cash -= amount
  end
end
