require_relative 'reader.rb'

class BoardingPass
  attr_reader :front_back, :left_right

  def initialize(directions:)
    @front_back = directions[0, 7].split('')
    @left_right = directions[7, 9].split('')
  end

  def row
    min = 0
    max = 127

    front_back.each do |letter|
      mid = (max - min) / 2.0

      if letter == 'F'
        max = min + mid.floor
      elsif letter == 'B'
        min = min + mid.ceil
      else
        raise 'invalid letter!'
      end
    end

    raise "invalid answer: min: #{min}, max: #{max}" unless min == max

    min
  end

  def column
    min = 0
    max = 7

    left_right.each do |letter|
      mid = (max - min) / 2.0

      if letter == 'L'
        max = min + mid.floor
      elsif letter == 'R'
        min = min + mid.ceil
      else
        raise 'invalid letter!'
      end
    end

    left_right.last == 'L' ? min : max
  end

  def seat_id
    row * 8 + column
  end
end

class PassChecker
  attr_reader :seat_ids

  def initialize(passes:)
    @seat_ids = calc_ids(passes)
  end

  def calc_ids(passes)
    seat_ids = []

    passes.map do |pass|
      seat_ids << BoardingPass.new(directions: pass).seat_id
    end

    seat_ids
  end

  def max_seat_id
    seat_ids.max
  end

  def sorted_seat_ids
    seat_ids.sort
  end

  def find_missing_seat
    (seat_ids.min..seat_ids.max).to_a - seat_ids
  end
end

# BFFFBBFRRR: row 70, column 7, seat ID 567.
# pass = BoardingPass.new(directions: 'BFFFBBFRRR')
# puts pass.row
# puts pass.column
# puts pass.seat_id

# FFFBBBFRRR: row 14, column 7, seat ID 119.
# pass = BoardingPass.new(directions: 'FFFBBBFRRR')
# puts pass.row
# puts pass.column
# puts pass.seat_id

# BBFFBBFRLL: row 102, column 4, seat ID 820.
# pass = BoardingPass.new(directions: 'BBFFBBFRLL')
# puts pass.row
# puts pass.column
# puts pass.seat_id

input = Reader.new(path: 'input_files/input_five.txt').values
checker = PassChecker.new(passes: input)
puts checker.find_missing_seat
# puts checker.sorted_seat_ids
