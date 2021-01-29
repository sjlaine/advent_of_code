require_relative 'reader.rb'

class Finder
  attr_reader :values

  def initialize(values:)
    @values = values
  end

  def find_pair
    x = 0
    y = 1

    while x < self.values.length - 1
      while y < self.values.length
        a = self.values[x].to_i
        b = self.values[y].to_i

        return [a, b] if (a + b == 2020)
        y += 1
      end

      x += 1
      y = x + 1
    end
  end

  def find_three
    x = 0
    y = 1
    z = 2

    while x < self.values.length - 2
      while y < self.values.length - 1
        while z < self.values.length
          a = self.values[x].to_i
          b = self.values[y].to_i
          c = self.values[z].to_i

          return [a, b, c] if (a + b + c == 2020)
          z += 1
        end

        y += 1
        z = y + 1
      end

      x += 1
      y = x + 1
    end
  end

  def find_set(index_arr, num_vals)
  # base case: if vals[last_idx] - vals[0] == num_vals
  # recursive case: return if sum, else find_set with
  end

  def find_rightmost_not_maxed(index_arr)
    idx = index_arr.length - 1 # 2 (3 values)
    left_shift = 0

    while idx >= 0
      if index_arr[idx] == self.values.length - left_shift # [198, 199, 200] at index 2 == 200 - 0
        p "in here"
        puts "idx: #{index_arr[idx]}, right_side: #{self.values.length}"

        idx -= 1 # move the pointer to the left one
        left_shift += 1
      else
        puts "idx? #{idx}"
        return idx
      end
    end
  end
end

class Multiplier
  attr_reader :nums

  def initialize(nums)
    @nums = nums
  end

  def get_product
    self.nums.reduce(:*)
  end
end

# values = Reader.new(path: 'input_files/input_one.txt').values

# pair = Finder.new(values: values).find_pair
# p pair
#
# three = Finder.new(values: values).find_three
# p three
#
# product_of_two = Multiplier.new(pair).get_product
# p product_of_two
#
# product_of_three = Multiplier.new(three).get_product
# p product_of_three
#

test = Finder.new(values: (1..200).to_a).find_rightmost_not_maxed([100, 197, 199, 200])
p test
