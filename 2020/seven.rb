require_relative 'reader.rb'

class BagParser
  attr_reader :rules
  attr_accessor :bags

  def initialize(rules:)
    @rules = rules
    @bags = {}
  end

  def parse_rules
    rules.each do |rule|
      split_rule = rule.split(' contain ')
      color = split_rule[0].split(' ')[0..-2].join('_')
      children = split_rule[1].split(',').map do |child|
        child = child.split(' ')[0..-2].join('_')
        next if child == 'other'
        child
      end.compact

      bags[color] ||= Bag.new(color: color, parents: [])
      parent = bags[color]

      children.each do |child|
        next if child == 'no_other'
        child_color = child[2..-1]
        cost = child[0]

        if bags[child_color]
          bags[child_color].add_parent(parent)
        else
          bags[child_color] = Bag.new(color: child_color, parents: [parent])
        end

        parent.add_child(child: bags[child_color], cost: cost)
      end
    end
  end
end

class Bag
  attr_reader :color
  attr_accessor :parents, :children

  def initialize(color:, parents:)
    @color = color
    @parents = parents
    @children = {} # { child1: 2, child2: 10, child3: 1 }
  end

  def add_parent(parent)
    parents << parent
  end

  def add_child(child:, cost:)
    children[child] = cost
  end

  def print_parents
    parents.map(&:color)
  end

  def bag_options
    current = self
    list = []
    queue = current.parents

    while queue.length > 0
      current.parents.each { |p| list << p }
      current = queue.shift

      current.parents.each do |p|
        queue << p if p
      end
    end

    list.flatten.map(&:color).uniq
  end

  def self.count_contents(node)
    return 0 unless node.children.length

    node.children.keys.map do |child|
      cost = node.children[child]
      child ? cost.to_i + cost.to_i * count_contents(child) : 0
    end.sum
  end
end

# light_red = Bag.new(color: 'light_red', parents: [])
# dark_orange = Bag.new(color: 'dark_orange', parents: [])
# muted_yellow = Bag.new(color: 'muted_yellow', parents: [light_red])
# bright_white = Bag.new(color: 'bright_white', parents: [dark_orange, light_red])
# shiny_gold = Bag.new(color: 'shiny_gold', parents: [bright_white, muted_yellow])
# dark_olive = Bag.new(color: 'dark_olive', parents: [shiny_gold])
# vibrant_plum = Bag.new(color: 'vibrant_plum', parents: [shiny_gold])
# dotted_black = Bag.new(color: 'dotted_black', parents: [vibrant_plum, dark_olive])
# faded_blue = Bag.new(color: 'faded_blue', parents: [muted_yellow, dark_orange, vibrant_plum])

# p dark_olive.bag_options.count

input = Reader.new(path: 'input_files/input_seven.txt').values
parser = BagParser.new(rules: input)
parser.parse_rules
vibrant_plum = parser.bags['vibrant_plum']
shiny_gold = parser.bags['shiny_gold']
# p shiny_gold.bag_options
p Bag.count_contents(shiny_gold)
