require_relative 'reader.rb'

class XmasChecker
  attr_reader :nums, :preamble

  def initialize(nums:, preamble:)
    @nums = nums
    @preamble = preamble
  end

  def check_nums
    (0..nums.length - 1).to_a.each do |idx|
      num = nums[idx + preamble]
      return num unless sum_exists?(num: num, arr: nums[idx..idx + preamble - 1])
    end
  end

  def sum_exists?(num:, arr:)
    x = 0
    y = 1

    while x < arr.length - 1
      while y < arr.length
        sum = arr[x] + arr[y]
        return true if sum == num

        y += 1
      end

      x += 1
      y = x + 1
    end

    false
  end

  def find_contiguous_sum(target:)
    x = 0
    y = 1

    while x < nums.length - 1
      while y < nums.length
        sum = nums[x..y].sum
        return sum_min_and_max(nums[x..y]) if sum == target

        y += 1
      end

      x += 1
      y = x + 1
    end

    false
  end

  def sum_min_and_max(arr)
    sorted = arr.sort

    sorted[0] + sorted[arr.length - 1]
  end
end


input = [ 35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576 ]

checker = XmasChecker.new(nums: input, preamble: 5)
# p checker.check_nums
p checker.find_contiguous_sum(target: 127)

input = Reader.new(path: 'input_files/input_nine.txt').values.map(&:to_i)
checker = XmasChecker.new(nums: input, preamble: 25)
answer_one = checker.check_nums
p answer_one
p checker.find_contiguous_sum(target: answer_one)

