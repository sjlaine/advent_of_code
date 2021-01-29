require_relative 'reader.rb'

class CustomsChecker
  attr_reader :groups

  def initialize(groups:)
    @groups = groups
  end

  def check_groups
    counts = []

    groups.each do |group|
      counts << rule_two_count(group)
    end

    counts.reduce(&:+)
  end

  def rule_one_count(group)
    group.split("\n").join('').split('').uniq.count
  end

  def rule_two_count(group)
    group.split("\n").reduce { |a, b| (a.split('') & b.split('')).join('') }.length
  end
end

input = Reader.new(path: 'input_files/input_six.txt').split_on_double_newlines

p CustomsChecker.new(groups: input).check_groups

