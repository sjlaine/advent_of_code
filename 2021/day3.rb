#!/usr/bin/env ruby

def most_common_at_idx(arr, idx)
  counts = [0, 0]

  arr.each do |num|
    num[idx] == '0' ? counts[0] += 1 : counts[1] += 1
  end

  return (counts[0] > counts[1]) ? 0 : 1
end

def least_common_at_idx(arr, idx)
  counts = [0, 0]

  arr.each do |num|
    num[idx] == '0' ? counts[0] += 1 : counts[1] += 1
  end

  return (counts[0] <= counts[1]) ? 0 : 1
end

def find_scrubber_rating
  report_vals = []

  File.open('day3_input.txt').each_with_index do |line, idx|
    report_vals << line
  end

  loop_count = 0
  filtered_vals = report_vals

  # oxygen gen rating
  while(filtered_vals.length > 1)
    filtered_vals = filtered_vals.select do |val|
      val[loop_count].to_i == most_common_at_idx(filtered_vals, loop_count)
    end

    oxygen_gen = filtered_vals[0] if filtered_vals.length == 1
    loop_count += 1
  end

  filtered_vals = report_vals
  loop_count = 0

  # co2 gen rating
  while(filtered_vals.length > 1)
    filtered_vals = filtered_vals.select do |val|
      val[loop_count].to_i == least_common_at_idx(filtered_vals, loop_count)
    end

    co2_gen = filtered_vals[0] if filtered_vals.length == 1
    loop_count += 1
  end

  p "oxygen_gen: #{oxygen_gen}, co2_gen: #{co2_gen}"
end

find_scrubber_rating


# "oxygen_gen: 101101100111, co2_gen: 011111010101"
# 2919 * 2005
