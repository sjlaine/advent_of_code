#!/usr/bin/env ruby

def count_increases
  prev = nil;
  count = 0;

  File.readlines('day1_input.txt').each_with_index do |line, idx|
    if (idx > 0)
      if (line.to_i > prev)
        count += 1
      end
    end

    prev = line.to_i
  end

  count
end

puts count_increases
