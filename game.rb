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
    issue_start_cards(@user)
    make_bet(@user)
    issue_start_cards(@bot)
    make_bet(@bot)
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
    if @user.cards.size < max_cards
      add_card(@user)
      show_user_hand(@user)
      bot_turn
    elsif @user.cards.size == max_cards && @bot.cards.size == max_cards
      end_game
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
    puts "Победил #{winner.name}"
    menu_end_game
  end

  def menu_end_game
    puts "У вас в банке #{@user.cash} денег"
    printf 'Продолжаем играть? у/n:'
    input = gets.chomp
    if input == 'y'
      start_game
    elsif input == 'n'
      puts 'Игра завершена!'
      exit!
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
    return @user if bot_score > win_points && user_score <= win_points
    return @bot if user_score > win_points && bot_score <= win_points
    return nil if user_score > win_points && bot_score > win_points
    return @user if user_score > bot_score
    return @bot if user_score < bot_score
    nil
  end

  def bot_turn
    if points(@bot.cards) < 17 && @bot.cards.size < max_cards
      add_card(@bot)
      puts 'Компьютер взял карту'
      user_turn
    elsif max_cards?
      puts 'У игроков максимальное количество карт'
      end_game
    else
      puts 'Компьютер пропускает ход'
      user_turn
    end
  end

  def max_cards?
    @user.cards.size == max_cards && @bot.cards.size == max_cards
  end

  def user_input
    menu
    printf 'Выбери пункт меню: '
    user_input = gets.chomp
    if %w(1 2 3 4).include?(user_input)
      user_input.to_i
    else
      puts 'Неправильный ввод'
      menu
    end
  end

  def issue_start_cards(player)
    player.cards = @deck.issue_cards(basic_card_amount)
  end

  def add_card(player)
    player.cards += @deck.issue_cards(1)
  end

  def make_bet(player)
    if player.cash - bet >= 0
      player.cash -= bet
      @bank += bet
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
    @user = Player.new(name, basic_cash)
  end

  def create_bot
    @bot = Player.new('Компьютер', basic_cash)
  end

  def create_deck
    @deck = Deck.new
  end
end
