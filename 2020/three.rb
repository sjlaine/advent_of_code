require_relative 'reader.rb'

class Skier
  attr_reader :slopes

  def initialize(slopes:)
    @slopes = slopes
  end

  def ski(x_inc:, y_inc:)
    # position = [down1][right3]
    x = 0
    y = 0
    max_x = self.slopes[y].length - 1
    trees = 0

    while self.slopes[y + y_inc]
      y += y_inc

      new_x = x + x_inc

      if self.slopes[y][new_x]
        x = new_x
      else
        x = (x_inc - (max_x - x) % x_inc) - 1
      end

      if self.slopes[y][x] == '#'
        trees += 1
      end
    end

    trees
  end
end

input = %w[
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
]

p Skier.new(slopes: input).ski(x_inc: 1, y_inc: 2)

input = Reader.new(path: 'input_files/input_three.txt').values

# a) Right 1, down 1.
a = Skier.new(slopes: input).ski(x_inc: 1, y_inc: 1)
puts a

# b) Right 3, down 1. -- 193
b = Skier.new(slopes: input).ski(x_inc: 3, y_inc: 1)
puts b

# c) Right 5, down 1.
c = Skier.new(slopes: input).ski(x_inc: 5, y_inc: 1)
puts c

# d) Right 7, down 1.
d = Skier.new(slopes: input).ski(x_inc: 7, y_inc: 1)
puts d

# e) Right 1, down 2.
e = Skier.new(slopes: input).ski(x_inc: 1, y_inc: 2)
puts e

puts a * b * c * d * e
