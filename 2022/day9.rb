require 'pry'

def rope_mechanics(rope_length: 2)
  visited = { 0 => { 0 => 1 }}
  rope = build_rope(rope_length, 0, 0)
  head = rope[:head]
  tail = rope[:tail]

  File.readlines('inputs/day9.txt').each do |line|
    move = line.chomp.split(' ')
    direction = move[0]
    step_count = move[1].to_i

    while(step_count > 0)
      move_head(head, direction)
      move_rope(head)
      
      tail_pos = tail.position

      if visited[tail_pos[0]] && visited[tail_pos[0]][tail_pos[1]]
        # do nothing
      elsif visited[tail_pos[0]]
        visited[tail_pos[0]][tail_pos[1]] = 1
      else
        visited[tail_pos[0]] = {}
        visited[tail_pos[0]][tail_pos[1]] = 1
      end

      step_count -= 1
    end
  end

  visited
end

def move_head(node, dir)
  pos = node.position

  case dir
  when 'U'
    pos[1] = pos[1] + 1
  when 'R'
    pos[0] = pos[0] + 1
  when 'D'
    pos[1] = pos[1] - 1
  when 'L'
    pos[0] = pos[0] - 1
  else
    raise 'unexpected direction!'
  end

  pos
end

def build_rope(length, start_x, start_y)
  head = Knot.new(position_x: start_x, position_y: start_y)
  current = head

  while (length > 1)
    next_knot = Knot.new(prev_knot: current, position_x: start_x, position_y: start_y)
    current.next_knot = next_knot
    current = next_knot

    length -= 1
  end

  { head: head, tail: current }
end

def move_rope(head)
  current = head
  moves = 0

  while(current.next_knot)
    move_tail(current.position, current.next_knot.position) unless tail_touching?(current, current.next_knot)
    current = current.next_knot
  end

  current
end

def tail_touching?(head, tail)
  (head.position[0] - tail.position[0]).abs <= 1 && (head.position[1] - tail.position[1]).abs <= 1
end

def move_tail(head, tail)
  # move diagonally
  if (head[0] - tail[0]).abs >= 1 && (head[1] - tail[1]).abs >= 1
    move_tail_y(head, tail)
    move_tail_x(head, tail)
  elsif (head[0] - tail[0]).abs > 1 # move y
    move_tail_y(head, tail)
  else # move x
    move_tail_x(head, tail)
  end
end

def move_tail_y(head, tail)
  head[0] > tail[0] ? tail[0] += 1 : tail[0] -= 1
end

def move_tail_x(head, tail)
  head[1] > tail[1] ? tail[1] += 1 : tail[1] -= 1
end

class Knot
  attr_accessor :prev_knot, :next_knot, :position

  def initialize(prev_knot: nil, next_knot: nil, position_x:, position_y:)
    @prev_knot = prev_knot
    @next_knot = next_knot
    @position = [position_x, position_y]
  end
end

# PART ONE
locations = []
rope_mechanics(rope_length: 2).values.each do |hash|
  locations << hash.values
end

puts "Part One: #{locations.flatten.sum}"

# PART TWO
locations = []
rope_mechanics(rope_length: 10).values.each do |hash|
  locations << hash.values
end

puts "Part Two: #{locations.flatten.sum}"