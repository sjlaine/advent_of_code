def signal_strengths
  cycle = 0
  sprite = 1
  saved_signals = []
  crt = build_crt

  File.readlines("inputs/day10.txt").each do |line|
    line = line.chomp
    
    if line == "noop"
      cycle += 1
      saved_signals << sprite * cycle if track_signal?(cycle)
      crt[cycle - 1] = "#" if sprite_touching?(sprite, cycle)
    else
      cycle += 1
      saved_signals << sprite * cycle if track_signal?(cycle)
      crt[cycle - 1] = "#" if sprite_touching?(sprite, cycle)
      cycle += 1
      saved_signals << sprite * cycle if track_signal?(cycle)
      crt[cycle - 1] = "#" if sprite_touching?(sprite, cycle)
      sprite += line.split(' ')[1].to_i
    end
  end

  [saved_signals, crt]
end

def build_crt
  crt = []
  count = 0

  while(count < 240)
    crt << "."
    count += 1
  end

  crt
end

def print_crt(crt)
  puts crt[0..39].join('')
  puts crt[40..79].join('')
  puts crt[80..119].join('')
  puts crt[120..159].join('')
  puts crt[160..199].join('')
  puts crt[200..239].join('')
end

def track_signal?(cycle)
  (cycle - 20) % 40 == 0
end

def sprite_touching?(sprite, cycle)
  [sprite - 1, sprite, sprite + 1].include?((cycle % 40) - 1)
end

answers = signal_strengths
puts "\n"
puts "PART ONE: #{signal_strengths[0].sum}"
puts "\n"

crt = signal_strengths[1]
puts "PART TWO:"
puts "\n"
print_crt(crt)