require 'pry'

def build_fs_tree
  root = Node.new(name: "/", parent: nil)
  current_node = root

  File.readlines('inputs/day7.txt').each do |line|
    els = line.chomp.split(' ')

    next if els[2] == "/" # already added root

    if els[0] == '$'
      if els[1] == 'cd'
        # move directories
        if els[2] == '..'
          # move up
          current_node = current_node.parent
        else
          # move down
          dirs = current_node.children
          dirs.each do |dir|
            current_node = dir if dir.name == els[2]
          end
          raise 'dir not found!' if current_node.nil?
        end
      elsif els[1] == 'ls'
        # stay
        next
      else
        raise 'unexpected command!'
      end
    elsif els[0] == 'dir'
      # make a new node in children
      new_dir = Node.new(name: els[1], parent: current_node)
      current_node.children << new_dir
    else
      # push file into current node
      current_node.files << els[0].to_i
    end
  end

  root
end

class Node
  attr_accessor :children, :parent, :name, :files, :size

  def initialize(name:, parent:)
    @name = name
    @parent = parent
    @children = []
    @files = []
  end

  def calc_size
    file_sum = @files.sum
    dir_sum = 0
    children.each do |child|
      child.children.each(&:calc_size)
      child.calc_size
      dir_sum += child.size
    end

    @size = file_sum + dir_sum
    @size
  end
end

def dfs(node, all_files = [], small_dirs = [])
  all_files.push(*node.files)
  current_size = node.calc_size unless node.children.map(&:calc_size).include?(false)
  small_dirs << node if current_size && current_size <= 100000

  node.children.each do |child|
    dfs(child, all_files, small_dirs)
  end

  small_dirs
end

def bfs(node)
  queue = []
  smalls = []
  deletable = []
  queue.push(node)

  while(queue.size != 0)
    node = queue.shift
    size = node.calc_size
    space_to_free = 6728267 # could use some cleanup to not hard-code this
    smalls << size if size <= 100000
    deletable << size if size >= space_to_free

    node.children.each do |child|
      queue.push(child)
    end
  end

  deletable.min
end

root = build_fs_tree
used_space = root.calc_size

p bfs(root)