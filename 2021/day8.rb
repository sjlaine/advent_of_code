#!/usr/bin/env ruby

def parse_input
  entries = []

  File.open('day8_input.txt').each_with_index do |line, idx|
    entries << line
  end

  entries.map do |entry|
    input_output = entry.split(' | ')
    input = input_output[0].split(' ')
    output = input_output[1].split(' ')

    {
      input: input,
      output: output
    }
  end
end

def count_output_digits_1478
  lengths = [2, 3, 4, 7]
  count = 0
  entries = parse_input

  entries.each do |entry|
    entry[:output].each do |output|
      count += 1 if lengths.include?(output.length)
    end
  end

  count
end

class Display
  attr_reader   :top,
                :topright,
                :topleft,
                :middle,
                :bottomright,
                :bottomleft,
                :bottom,
                :segments,
                :digits_hash

  def initialize(segments:)
    @segments = segments

    set_topright_bottomright
    set_top
    set_middle
    set_middle_bottom
    set_tl_tr_br
    set_bottomleft

    set_digits_hash
  end

  def set_topright_bottomright
    two = segments[:'2'].first.split('')
    @topright = two
    @bottomright = two
  end

  def set_top
    three = segments[:'3'].first

    @top = three.split('') - topright
  end

  def set_middle
    four = segments[:'4'].first.split('')
    two = segments[:'2'].first.split('')
    @middle = four - two
  end

  def set_middle_bottom
    five = segments[:'5']
    intersection = five[0].split('') & five[1].split('') & five[2].split('')
    middle_bottom = intersection - top

    @middle = (middle_bottom) & middle
    @bottom = (middle_bottom) - middle
  end

  def set_tl_tr_br
    six = segments[:'6']

    intersection = six[0].split('') & six[1].split('') & six[2].split('')

    @topleft = intersection - top - bottom - bottomright
    @bottomright = intersection - top - bottom - topleft
    @topright = topright - bottomright
  end

  def set_bottomleft
    seven = segments[:'7'].first.split('')
    @bottomleft = seven - top - topright - topleft - middle - bottomright - bottom
  end

  def sort(arr)
    arr.sort { |a, b| a <=> b }.join('')
  end

  def set_digits_hash
    eight = segments[:'7'].first.split('')
    zero = eight - middle
    two = eight - topleft - bottomright
    nine = eight - bottomleft
    three = nine - topleft
    six = eight - topright
    five = six - bottomleft
    four = segments[:'4'].first.split('')
    one = segments[:'2'].first.split('')
    seven = segments[:'3'].first.split('')


    @digits_hash = {
      sort(zero) => 0,
      sort(one) => 1,
      sort(two) => 2,
      sort(three) => 3,
      sort(four) => 4,
      sort(five) => 5,
      sort(six) => 6,
      sort(seven) => 7,
      sort(eight) => 8,
      sort(nine) => 9
    }
  end

  def calc_output_code(output:)
  code = ''

  output.each do |val|
    code += digits_hash[sort(val.split(''))].to_s
  end

  code
end
end

# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf

def sort_segments(inputs:)
  segments = {}

  inputs.each do |input|
    len = input.length.to_s.to_sym

    if(segments[len])
      segments[len] << input
    else
      segments[len] = [input]
    end
  end

  segments
end

# entries = parse_input
# segments = sort_segments(inputs: entries.first[:input])

# For each line:
# get entries, then sort segments
# make new display
# display calc output code

def find_codes(entries:)
  codes = []

  entries.each do |entry|
    segments = sort_segments(inputs: entry[:input])
    display = Display.new(segments: segments)

    codes << display.calc_output_code(output: entry[:output]).to_i
  end

  codes
end

# display = Display.new(segments: segments)
# puts "output code: #{display.calc_output_code(entries.first[:output])}"

entries = parse_input
puts find_codes(entries: entries).sum
