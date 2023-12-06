TARGETS = {
  red: 12,
  blue: 14,
  green: 13
}

def parse_games(filepath)
  file_lines = File.readlines(filepath)
  file_lines.each_with_index.map do |line, idx|
    parse_game(line)
  end
end

def find_games(cube_counts)
  cube_counts.each_with_index.map do |line, idx|
    game_results = line.map do |count|
      num, color = count.split(" ")
      TARGETS[color.to_sym] >= num.to_i
    end
  
    game_results.include?(false) ? 0 : idx + 1
  end.sum
end

def find_game_power(round_set)
  max_counts = {
    red: 0,
    green: 0,
    blue: 0
  }

  round_set.each do |count|
    num, color = count.split(" ")
    if num.to_i > max_counts[color.to_sym]
      max_counts[color.to_sym] = num.to_i
    end
  end

  max_counts.values.reduce(&:*)
end

def parse_game(line)
  line.split(":").drop(1).first.strip.split("; ").map { |round| round.split(", ") }.flatten
end

ARGV.each do |filepath|
  cube_counts = parse_games(filepath)
  puts "Part One: #{find_games(cube_counts)}"

  total_power = cube_counts.map do |count|
    find_game_power(count)
  end.sum

  puts "Part Two: #{total_power}"
end