def fully_contained_pairs
  fully_contained = 0
  overlap = 0

  file_lines = File.readlines('inputs/day4.txt')
  file_lines.each do |line|
    pair = line.chomp.split(',').map { |pair| pair.split('-').map(&:to_i) }

    fully_contained += 1 if fully_contained?(pair) || fully_contained?(flip_pair(pair))
    overlap += 1 if any_overlap?(pair) || any_overlap?(flip_pair(pair))
  end

  [fully_contained, overlap]
end

def flip_pair(pair)
  [pair[1], pair[0]]
end

def fully_contained?(pair)
  pair[0][0] <= pair[1][0] && pair[0][1] >= pair[1][1]
end

def any_overlap?(pair)
  pair[0][0] <= pair[1][0] && pair[0][1] >= pair[1][0]
end

p fully_contained_pairs