require_relative 'reader.rb'

class JoltageChecker
  attr_reader :adapters

  def initialize(adapters)
    @adapters = adapters.sort
  end

  def find_differences
    differences = { one: 0, three: 1 }

     differences[:one] += 1 if adapters.first - 0 == 1
     differences[:three] += 1 if adapters.first - 0 == 3

    (0..adapters.length - 1).to_a.each do |idx|
      differences[:one] += 1 if adapters[idx] - adapters[idx - 1] == 1
      differences[:three] += 1 if adapters[idx] - adapters[idx - 1] == 3
    end

    differences
  end

  def possibilities_hash
    adapter_hash = {}

    adapters.map { |a| adapter_hash[a] = 0 }

    adapters.each do |adapter|
      poss = 0

      (1..3).each do |n|
        if adapter_hash[adapter - n]
          poss += 1
        end
      end

      adapter_hash[adapter] = poss
    end

    adapter_hash
  end

  def find_permutations
    possibilities_hash.values
  end
end

input = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]

checker = JoltageChecker.new(input)
p checker.find_differences
p checker.possibilities_hash
p checker.find_permutations

input = [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38,
          39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3 ]

checker = JoltageChecker.new(input)
p checker.find_differences
p checker.possibilities_hash
p checker.find_permutations

# input = Reader.new(path: 'input_files/input_ten.txt').values.map(&:to_i)
# checker = JoltageChecker.new(input)
# p checker.find_differences
