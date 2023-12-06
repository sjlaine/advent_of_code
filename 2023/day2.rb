TARGETS = {
  red: 12,
  blue: 14,
  green: 13
}

def find_games(filepath)
  file_lines = File.readlines(filepath)
  res = file_lines.each_with_index.map do |line, idx|
    cube_counts = parse_game(line, idx)
    game_results = cube_counts.map do |count|
      num, color = count.split(" ")
      TARGETS[color.to_sym] >= num.to_i
    end
  
    game_results.include?(false) ? 0 : idx + 1
  end

  res.sum
end

def parse_game(line, idx)
  line.split(":").drop(1).first.strip.split("; ").map { |round| round.split(", ") }.flatten
end

ARGV.each do |filepath|
  puts find_games(filepath)
end