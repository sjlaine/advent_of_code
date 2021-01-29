require_relative 'reader.rb'

class InstructionParser
  attr_reader :lines

  def initialize(lines)
    @lines = lines
  end

  def parse
    instructions = []
    lines.each do |line|
      split = line.split(' ')

      instructions << { split[0].to_sym => [split[1][0], split[1][1..-1].to_i] }
    end

    instructions
  end
end

class BootChecker
  attr_reader :instructions

  def initialize(instructions)
    @instructions = instructions # [{'nop': ['+', 0] }, { 'acc': ['+', 1] }, { 'jmp': ['-', 4] }]
  end

  def find_infinite_loop(lines:)
    visited = {}
    accumulator = 0
    idx = 0

    result = 'no result found?'

    while 1 == 1
      line = lines[idx]

      unless lines[idx]
        result = 'program terminated!'
        break
      end

      if visited[idx]
        result = 'infinite loop!'
        break
      end

      visited[idx] = 'visited'

      type = line.keys.first.to_s
      op = line.values.first[0]
      val = line.values.first[1]

      raise 'Invalid operation' unless %w[+ -].include?(op)
      raise 'Value must be of type Integer' unless val.is_a? Integer

      case type
      when 'nop'
        idx += 1
      when 'acc'
        op == '+' ? accumulator += val : accumulator -= val
        idx += 1
      when 'jmp'
        op == '+' ? idx += val : idx -= val
      else
        raise 'Unrecognized type!'
      end
    end

    puts "accumulator: #{accumulator}"
    result
  end

  def find_fix
    new_instructions = instructions

    instructions.each_with_index do |line, idx|
      type = line.keys.first.to_s
      next if type == 'acc'

      if type == 'nop'
        new_instructions[idx][:jmp] = new_instructions[idx].delete :nop
      else
        new_instructions[idx][:nop] = new_instructions[idx].delete :jmp
      end

      if find_infinite_loop(lines: new_instructions) == 'program terminated!'
        puts "found fix at idx: #{idx}"
        break
      end

      if type == 'nop'
        new_instructions[idx][:nop] = new_instructions[idx].delete :jmp
      else
        new_instructions[idx][:jmp] = new_instructions[idx].delete :nop
      end
    end
  end
end


# nop +0
# acc +1
# jmp +4
# acc +3
# jmp -3
# acc -99
# acc +1
# jmp -4
# acc +6

input1 = [
  { 'nop': ['+', 0] },
  { 'acc': ['+', 1] },
  { 'jmp': ['+', 4] },
  { 'acc': ['+', 3] },
  { 'jmp': ['-', 3] },
  { 'acc': ['-', 99] },
  { 'acc': ['+', 1] },
  { 'jmp': ['-', 4] },
  { 'acc': ['+', 6] }
]

# checker = BootChecker.new(input1)
# p checker.find_infinite_loop(lines: input1)
# checker.find_fix

values = Reader.new(path: 'input_files/input_eight.txt').values
input = InstructionParser.new(values).parse
checker = BootChecker.new(input)
# p checker.find_infinite_loop(lines: input)
checker.find_fix
