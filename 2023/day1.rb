#!/usr/bin/env ruby

SPELLED_NUMS = {
  "oneight": "18",
  "twone": "21",
  "threeight": "38",
  "fiveight": "58",
  "sevenine": "79",
  "eightwo": "82",
  "eighthree": "83",
  "nineight": "98",
  "one": "1",
  "two": "2",
  "three": "3",
  "four": "4",
  "five": "5",
  "six": "6",
  "seven": "7",
  "eight": "8",
  "nine": "9" 
}

def sum_calibration_values(filepath)
  file_lines = File.readlines(filepath)

  spelled_nums_regex = Regexp.new(SPELLED_NUMS.keys.join("|"))
  all_nums = file_lines.each_with_index.map do |line, idx|
    nums = line.scan(/\d+|#{spelled_nums_regex}/)

    nums = [
      coerce_to_i(num: nums.first, first: true),
      coerce_to_i(num: nums.last, first: false)
    ]

    p "#{idx}: #{nums.join}"
    
    nums.join.to_i
  end.sum
end

def coerce_to_i(num:, first:)
  found_num = if SPELLED_NUMS.keys.include?(num.to_sym)
    SPELLED_NUMS[num.to_sym]
  else
    num
  end.split("")

  first ? found_num.first : found_num.last
end

ARGV.each do |filepath|
  puts sum_calibration_values(filepath)
end