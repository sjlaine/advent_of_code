require "pry"

SPECIAL_CHARS = [ "[", "]", "," ].freeze

def check_packets(file)
  left = []
  right = []
  correct_order = []

  File.readlines(file).each_with_index do |line, idx|
    case idx % 3
    when 0
      left = eval line.chomp
    when 1
      right = eval line.chomp

      if run_comparison(left, right)
        correct_order << (idx + 2) / 3
      end
    when 2
      # do nothing
    end
  end

  correct_order
end

def run_comparison(left, right)
  return true if left.nil?
  return false if right.nil?
  idx = 0
  max_len = [left.length, right.length].max
  
  while(idx < max_len)
    return true if left[idx].nil? && right[idx]
    return false if left[idx] && right[idx].nil?

    if left[idx].is_a?(Integer) && right[idx].is_a?(Integer) && left[idx] != right[idx]
      return left[idx] < right[idx]
    end

    result = if left[idx].is_a?(Integer) && right[idx].is_a?(Array)
      run_comparison([left[idx]], right[idx])
    elsif right[idx].is_a?(Integer) && left[idx].is_a?(Array)
      run_comparison(left[idx], [right[idx]])
    elsif right[idx].is_a?(Array) && left[idx].is_a?(Array)
      run_comparison(left[idx], right[idx])
    else
      nil
    end

    return result unless result.nil?

    idx += 1
  end
end

# left = [1,1,3,1,1]
# right = [1,1,5,1,1]
# p run_comparison(left, right)

# left = [[1],[2,3,4]]
# right = [[1],4]
# p run_comparison(left, right)

# left = [9]
# right = [[8,7,6]]
# p run_comparison(left, right)

# left = [[4,4],4,4]
# right = [[4,4],4,4,4]
# p run_comparison(left, right)

# left = [7,7,7,7]
# right = [7,7,7]
# p run_comparison(left, right)

# left = []
# right = [3]
# p run_comparison(left, right)

# left = [[[]]]
# right = [[]]
# p run_comparison(left, right)

# left = [1,[2,[3,[4,[5,6,7]]]],8,9]
# right = [1,[2,[3,[4,[5,6,0]]]],8,9]
# p run_comparison(left, right)

p check_packets("inputs/day13_test.txt").sum
# p check_packets("inputs/day13.txt")
p check_packets("inputs/day13.txt").sum