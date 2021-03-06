class Game
  include Blackjack

  attr_reader :user, :bot, :deck
  attr_writer :bank

  def initialize
    create_user
    create_bot
    @bank = 0
  end

  def start_game
    create_deck
    erase_players_cards
    [@user, @bot].each do |player|
      issue_start_cards(player)
      make_bet(player)
    end
    show_user_hand(@user)
    user_turn
  end

  private

  def user_turn
    input = user_input
    case input
    when 1 then menu_add_card
    when 2 then menu_skip_turn
    when 3 then end_game
    when 0 then exit!
    end
  end

  def menu_add_card
    if @user.cards.size < MAX_CARDS
      add_card(@user)
      show_user_hand(@user)
      bot_turn
    else
      puts 'У вас уже максимальное кол-во карт'
      user_input
    end
  end

  def menu_skip_turn
    puts 'Вы пропустили ход'
    bot_turn
  end

  def end_game
    user_score = points(@user.cards)
    bot_score = points(@bot.cards)
    winner = get_winner(user_score, bot_score)
    show_me_the_money(winner)
    show_user_hand(@bot)
    winner.nil? ? puts('Ничья') : puts("Победил #{winner.name}")
    menu_end_game
  end

  def menu_end_game
    puts "У вас в банке #{@user.cash} денег"
    printf 'Продолжаем играть? у/n:'
    input = gets.chomp
    case input
    when 'y' then start_game
    when 'n' then exit!
    else
      puts 'Неправильный ввод'
      menu_end_game
    end
  end

  def show_me_the_money(winner)
    winner.cash += @bank if winner
    @bank = 0
  end

  def get_winner(user_score, bot_score)
    return nil if dead_heat?(user_score, bot_score)
    return @bot if overscored?(user_score)
    return @user if overscored?(bot_score)
    return @bot if user_score < bot_score
    @user
  end

  def overscored?(score)
    score > WIN_POINTS
  end

  def dead_heat?(user_score, bot_score)
    overscored = overscored?(user_score) && overscored?(bot_score)
    equals = user_score == bot_score
    overscored || equals
  end

  def bot_turn
    if points(@bot.cards) < 17 && @bot.cards.size < MAX_CARDS
      add_card(@bot)
      puts 'Компьютер взял карту'
    else
      puts 'Компьютер пропускает ход'
    end
    end_game if max_cards?
    user_turn
  end

  def max_cards?
    @user.cards.size == MAX_CARDS && @bot.cards.size == MAX_CARDS
  end

  def user_input
    menu
    printf 'Выбери пункт меню: '
    user_input = gets.chomp
    if %w(1 2 3 0).include?(user_input)
      user_input.to_i
    else
      puts 'Неправильный ввод'
      menu
    end
  end

  def issue_start_cards(player)
    player.cards = @deck.issue_cards(BASIC_CARD_AMOUNT)
  end

  def add_card(player)
    player.cards += @deck.issue_cards(1)
  end

  def make_bet(player)
    if player.cash - BET >= 0
      player.cash -= BET
      @bank += BET
    else
      puts "У игрока #{player.name} закончились деньги"
      puts 'Игра завершена'
      exit!
    end
  end

  def menu
    puts '1. Добавить карту'
    puts '2. Пропустить ход'
    puts '3. Открыть карты'
    puts '0. Выход из игры'
  end

  def show_user_hand(player)
    printf "Карты #{player.name}: "
    cards = player.cards
    cards.each { |card| printf card.to_s + ' ' }
    printf ',очки: ' + points(cards).to_s
    puts ' '
  end

  def erase_players_cards
    @user.cards = []
    @bot.cards = []
  end

  def create_user
    printf 'Введи свое имя:'
    name = gets.chomp
    @user = Player.new(name, BASIC_CASH)
  end

  def create_bot
    @bot = Player.new('Компьютер', BASIC_CASH)
  end

  def create_deck
    @deck = Deck.new
  end
end
