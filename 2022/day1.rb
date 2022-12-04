#!/usr/bin/env ruby

NEWLINE = "\n".freeze

def count_elf_cals(num_to_keep: 1)
  current_cals = 0
  highest_cals = []
  current_elf = 0

  file_lines = File.readlines('inputs/day1.txt')
  file_lines.each_with_index do |line, idx|
    if line == NEWLINE
      if current_elf < num_to_keep
        highest_cals << current_cals
        current_cals = 0
        current_elf += 1
      else
        if new_max?(highest_cals, current_cals)
          highest_cals.delete(highest_cals.min)
          highest_cals << current_cals 
        end

        current_cals = 0
      end

    else
      current_cals += line.chomp.to_i
    end
  end

  highest_cals
end

def new_max?(highest_cals, current_cals)
  current_cals > highest_cals.min
end

p count_elf_cals(num_to_keep: 3).sum