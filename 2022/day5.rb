BLANKS = [' ', '[', ']']
def move_stacks
  stacks = []
  pt2_stacks = []
  cloned_stacks = false

  file_lines = File.readlines('inputs/day5.txt')
  file_lines.each do |line|
    next if line == "\n"
    next if line[1] == '1'
    
    unless line[0] == 'm'
      line.chomp.split('').each_with_index do |char, idx|
        unless BLANKS.include?(char)
          position = (idx / 4) + 1
          if stacks[position]
            stacks[position].unshift(char)
          else
            stacks[position] = [char]
          end
        end
      end
    end

    if line[0] == 'm' && !cloned_stacks
      pt2_stacks = deep_clone(stacks)
      cloned_stacks = true
    end

    if line[0] == 'm'
      moves = line.split(' ')
      num_boxes = moves[1].to_i
      origin = moves[3].to_i
      destination = moves[5].to_i

      pt2_stacks[destination].push(*pt2_stacks[origin].slice!(-num_boxes..))

      while num_boxes > 0
        stacks[destination].push(stacks[origin].pop)
        num_boxes -= 1
      end
    end
  end

  message = ''
  stacks.each do |stack|
    next if stack.nil? || stack.last.nil?
    message += stack.last
  end

  pt2_message = ''
  pt2_stacks.each do |stack|
    next if stack.nil? || stack.last.nil?
    pt2_message += stack.last
  end

  [message, pt2_message]
end

def deep_clone(arr)
  new_arr = []
  arr.each do |sub_arr|
    new_arr.push(sub_arr.clone)
  end

  new_arr
end

messages = move_stacks
puts "Part One: #{messages[0]}, Part Two: #{messages[1]}"