#!/usr/bin/env ruby

LETTERS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze
KNAPSACKS = File.readlines('inputs/day3.txt').freeze

def sum_priorities
  sum = 0

  KNAPSACKS.each do |knapsack|
    item = item_in_all(split_halves(knapsack.chomp))

    sum += priority(item)
  end

  sum
end

def find_badges
  current_group = []
  badge_sum = 0

  KNAPSACKS.each_with_index do |knapsack, idx|
    current_group << knapsack.chomp.split('')

    if (idx + 1) % 3 == 0
      badge_sum += priority(item_in_all(current_group))
      current_group = []
    end
  end

  badge_sum
end

def priority(letter)
  LETTERS.index(letter) + 1
end

def item_in_all(sacks)
  shared = sacks.reduce(:&)

  raise 'more than one common item!' unless shared.length == 1
  shared.first
end

def split_halves(str)
  middle = mid_idx(str)
  first_half = str[0..middle]
  second_half = str[middle+1..]

  [first_half.split(''), second_half.split('')]
end

def mid_idx(str)
  (str.length / 2) - 1
end

p sum_priorities
p find_badges