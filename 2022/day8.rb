def build_forest
  file_path = 'inputs/day8.txt'
  lines = File.readlines(file_path)
  top_left = nil
  row_above = []
  current_row = []
  all_trees = []
  
  lines.each_with_index do |line, y|
    left = nil
    tree_line = line.chomp.split('')
    tree_line.each_with_index do |tree, x|
      if y == 0 && x == 0
        top_left = Tree.new(height: tree.to_i)
        all_trees << top_left
        current_row << top_left
        left = top_left
      else
        top = row_above[x]
        current = Tree.new(height: tree.to_i, left: left, top: top)
        current_row << current
        all_trees << current
        top.bottom = current if top
        left.right = current if left
        left = current
      end
    end

    row_above = current_row
    current_row = []
  end

  all_trees
end

def plan_treehouse_location(trees)
  count = 0
  max_score = 0

  trees.each do |tree|
    count += 1 if check_visible(tree)
    current_score = scenic_score(tree)

    max_score = current_score if current_score > max_score
  end

  [count, max_score]
end

def check_visible(tree)
  surrounding = [tree.top, tree.bottom, tree.right, tree.left]
  return true if surrounding.any?(&:nil?)

  [check_dir(tree, :top), check_dir(tree, :bottom), check_dir(tree, :right), check_dir(tree, :left)].any?
end

def scenic_score(tree)
  [visible_trees(tree, :top), visible_trees(tree, :bottom), visible_trees(tree, :right), visible_trees(tree, :left)].reduce(:*)
end

def check_dir(tree, dir)
  current = tree

  while(current.send(dir))
    return false if current.send(dir).height >= tree.height
    current = current.send(dir)
  end

  true
end

def visible_trees(tree, dir)
  current = tree
  visible = 0

  while(current.send(dir))
    visible += 1
    return visible if current.send(dir).height >= tree.height
    current = current.send(dir)
  end

  visible
end

class Tree
  attr_accessor :left, :right, :top, :bottom, :height

  def initialize(left: nil, right: nil, top: nil, bottom: nil, height:)
    @left = left
    @right = right
    @top = top
    @bottom = bottom
    @height = height
  end
end

all_trees = build_forest
answers = plan_treehouse_location(all_trees)
puts "Part One: #{answers[0]}"
puts "Part Two: #{answers[1]}"