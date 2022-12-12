require 'pry'

def get_starting_point
  monkeys = {}
  current_monkey = nil

  File.readlines("inputs/day11.txt").each_with_index do |line, idx|
    case instruction_type(idx)
    when 0
      # do nothing
    when 1
      current_monkey = find_monkey_num(line)
      monkeys[current_monkey] = {}
      monkeys[current_monkey][:inspections] = 0
    when 2
      monkeys[current_monkey][:items] = starting_items(line)
    when 3
      monkeys[current_monkey][:operation] = get_operation(line)
    when 4
      monkeys[current_monkey][:test] = get_test(line)
    when 5
      # if true
      monkeys[current_monkey][:if_true] = throw_to_monkey(line)
    when 6
      # if false
      monkeys[current_monkey][:if_false] = throw_to_monkey(line)
    end
  end

  monkeys
end

def monkey_shenanigans(monkeys, rounds = 20, divisor = 3)
  while(rounds > 0)
    monkeys.values.each do |monkey|
      play_round(monkeys, monkey, divisor)
    end

    rounds -= 1
  end

  monkeys
end

def play_round(monkeys, monkey, divisor)
  items = monkey[:items]
  operation = monkey[:operation]
  test_num = monkey[:test]
  if_true = monkey[:if_true]
  if_false = monkey[:if_false]

  common_mult = monkeys.values.map { |m| m[:test] }.reduce(:*) # nums are all prime
  monkey[:inspections] += items.size

  while(items.any?)
    item = items.first
    num = operation[1] == "old" ? item : operation[1]
    item = item.send(operation[0].to_sym, num)
    item = item / divisor
    item = item % common_mult

    if run_test(item, test_num)
      monkeys[if_true][:items] << item
    else
      monkeys[if_false][:items] << item
    end

    items.shift
  end
end

def run_test(num, test_num)
  num % test_num == 0
end

def instruction_type(idx)
  (idx + 1) % 7
end

def find_monkey_num(line)
  line.chomp.split(' ')[1].chop
end

def starting_items(line)
  line.chomp.tr(",", "").split(" ")[2..].map(&:to_i)
end

def get_operation(line)
  operation = line.chomp.split(" ")[4..]
  operation[1] = operation[1].to_i unless operation[1] == "old"
  operation
end

def get_test(line)
  line.chomp.split(" ").last.to_i
end

def throw_to_monkey(line)
  line.chomp.split(" ").last
end

def print_monkeys(monkeys)
  monkeys.each_with_index do |m, idx|
    puts "Monkey #{idx + 1}: #{m}"
    puts "\n"
  end
end

def calc_monkey_business(monkeys)
  vals = []
  monkeys.values.each do |monkey|
    vals << monkey[:inspections]
  end

  vals.sort[-2..].reduce(:*)
end

monkeys = get_starting_point
final_monkeys = monkey_shenanigans(monkeys, 20, 3)
puts "Part One: #{calc_monkey_business(final_monkeys)}"
puts "\n"

monkeys_2 = get_starting_point
final_monkeys_2 = monkey_shenanigans(monkeys_2, 10_000, 1)
puts "Part Two: #{calc_monkey_business(final_monkeys_2)}"
