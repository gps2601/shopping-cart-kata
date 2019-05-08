class ShopItem
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def formatted_price
    format("£%.2f", price)
  end
end

def load_shopping_items(filename = "items.csv")
  shopping_items = {}
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, price = line.chomp.split(',')
    shopping_items[name] = ShopItem.new(name, price.to_f)
  end
  file.close
  shopping_items
end

class Checkout
  attr_reader :shopping_items
  def initialize
    @shopping_items = load_shopping_items
    @basket = []
  end

  def add_item_to_basket(user_input)
    @basket.push(@shopping_items[user_input])
  end

  def basket_total
    @basket.inject(0){|sum,x| sum + x.price}
  end

  def basket_total_formatted
    format("£%.2f", basket_total)
  end
end

def run_checkout
  @items = load_shopping_items
  while true
    print_menu
    process(gets.chomp)
  end
end

def print_menu
  puts "What would you like to do?"
  puts "1. Check an items price"
  puts "2. Checkout my shopping"
  puts "9. Shutdown the checkout"
end

def process(selection)
  case selection
  when "1"
    check_an_items_price
  when "2"
    perform_checkout
  when "9"
    exit
  else
    puts "Operation not recognised, try again"
  end
end

def check_an_items_price
  puts "What item would you like to check?"
  users_item = gets.chomp
  if !@items[users_item].nil?
    puts @items[users_item].formatted_price
  else
    puts "We dont have this item, sorry!"
  end
end

def perform_checkout
  checkout = Checkout.new
  puts "Please begin inputting your items"
  while true
    puts "Enter an item to add to basket or enter 'finish' to pay"
    user_input = gets.chomp
    if user_input == "finish"
      break
    elsif checkout.shopping_items[user_input].nil?
      puts "Sorry, we dont have this item, try again"
    else
      checkout.add_item_to_basket(user_input)
    end
  end
  puts "You total is #{checkout.basket_total_formatted}, please pay me now..."
  amount_paid = 0
  total = checkout.basket_total
  while amount_paid < total
    puts "You owe a total of #{format("£%.2f", total - amount_paid)}"
    puts "How much are you paying?"
    user_payment = gets.chomp
    if user_payment.to_f
      amount_paid += user_payment.to_f
      puts "You have made a payment of #{format("£%.2f", user_payment.to_f)}!"
    else
      puts "Not a valid amount, please try again"
    end
  end
  if amount_paid > total
    puts "Here is your change of #{format("£%.2f", amount_paid - total)}"
  end
  puts "All done, thanks for shopping with us!"
end

run_checkout