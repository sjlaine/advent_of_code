require "pry"

HEIGHTS = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z].freeze

def build_hills(file_path)
  lines = File.readlines(file_path)
  starting_point = nil
  possible_starts = []
  destination = nil
  row_above = []
  current_row = []
  
  lines.each_with_index do |line, y|
    left = nil
    hill_line = line.chomp.split('')
    hill_line.each_with_index do |peak, x|
      top = row_above[x]
      current = Peak.new(height: height(peak), left: left, top: top, name: "#{y}#{x}")
      current_row << current
      top.bottom = current if top
      left.right = current if left
      left = current

      if peak == "S"
        starting_point = current
        possible_starts << current
      end

      if peak == "a"
        possible_starts << current
      end

      if peak == "E"
        current.destination = true
        destination = current
      end
    end

    row_above = current_row
    current_row = []
  end

  [starting_point, possible_starts]
end

def height(peak)
  case peak
  when "S"
    1
  when "E"
    26
  else
    HEIGHTS.index(peak) + 1
  end
end

def find_path(start)
  current_best_path = Float::INFINITY
  queue = [{ length: 0, node: start, visited: [] }]
  node_costs = { "00" => 0 }

  while(queue.length > 0)
    current = queue.shift
    visited = current[:visited]

    new_length = current[:length] + 1
    # push each direction in and increase length by 1
    if new_length < current_best_path
      if current[:node].destination
        current_best_path = current[:length]
      else
        push_nodes(queue: queue, current: current, new_length: new_length, node_costs: node_costs)
      end
    end
  end

  current_best_path
end

def push_nodes(queue:, current:, new_length:, node_costs:)
  node = current[:node]
  visited = current[:visited]
  visited << node

  directions = %i[top bottom right left]
  
  directions.each do |direction|
    next_node = node.send(direction)
    if next_node && !visited.include?(next_node) && (next_node.height - node.height) <= 1 && less_costly_path?(node_costs, next_node, new_length)
      queue << { length: new_length, node: next_node, visited: visited.dup }
      node_costs[next_node.name] = new_length
    end
  end
end

def less_costly_path?(node_costs, next_node, new_length)
  node_costs[next_node.name].nil? || new_length < node_costs[next_node.name]
end

class Peak
  attr_accessor :left, :right, :top, :bottom, :height, :destination, :name

  def initialize(left: nil, right: nil, top: nil, bottom: nil, height:, destination: nil, name:)
    @left = left
    @right = right
    @top = top
    @bottom = bottom
    @height = height
    @destination = destination
    @name = name
  end
end

class Node
  attr_accessor :next_node, :height

  def initialize(next_node:, height:)
    @next_node = next_node
    @height = height
  end
end

start_node = build_hills('inputs/day12_test.txt')[0]
p find_path(start_node)

start_node_2 = build_hills('inputs/day12.txt')[0]
p find_path(start_node_2)

possible_starts = build_hills('inputs/day12.txt')[1]
solution = possible_starts.map do |start|
  path = find_path(start)
  path unless path > 100_000
end.compact.min

p solution