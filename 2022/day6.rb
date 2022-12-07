def find_marker(message_length)
  buffer = []
  input = File.readlines('inputs/day6.txt').first.chomp.split('')

  input.each_with_index do |char, idx|
    # push into buffer
    buffer.push(char)
    buffer.shift if buffer.length > message_length

    # check if buffer has num uniq letters to match message length
    if buffer.uniq.count == message_length
      return idx + 1
    end
  end
end

p find_marker(4)
p find_marker(14)