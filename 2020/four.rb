require_relative 'reader.rb'

class PassportChecker
  attr_reader :passports

  def initialize(passports:)
    @passports = passports.map(&:chomp)
  end

  def count_valid_passports
    count = 0

    passports.each do |passport|
      count += 1 if valid_passport?(passport)
    end

    count
  end

  def valid_passport?(passport)
    %w[hcl iyr eyr ecl pid byr hgt].each do |code|
      return false unless passport.include?("#{code}:")
    end

    passport_arr = passport.split(' ')
    hcl = passport_arr.select { |s| s.include?('hcl:') }.first[4..-1]
    iyr = passport_arr.select { |s| s.include?('iyr:') }.first[4..-1]
    eyr = passport_arr.select { |s| s.include?('eyr:') }.first[4..-1]
    ecl = passport_arr.select { |s| s.include?('ecl:') }.first[4..-1]
    pid = passport_arr.select { |s| s.include?('pid:') }.first[4..-1]
    byr = passport_arr.select { |s| s.include?('byr:') }.first[4..-1]
    hgt = passport_arr.select { |s| s.include?('hgt:') }.first[4..-1]

    Passport.new(hcl: hcl, iyr: iyr, eyr: eyr, ecl: ecl, pid: pid, byr: byr, hgt: hgt).valid?
  end
end

class Passport
  attr_reader :hcl, :iyr, :eyr, :ecl, :pid, :byr, :hgt

  def initialize(hcl:, iyr:, eyr:, ecl:, pid:, byr:, hgt:)
    @hcl = hcl
    @iyr = iyr
    @eyr = eyr
    @ecl = ecl
    @pid = pid
    @byr = byr
    @hgt = hgt
  end

  def valid?
    valid_hcl? &&
    valid_iyr? &&
    valid_eyr? &&
    valid_pid? &&
    valid_byr? &&
    valid_hgt? &&
    valid_ecl?
  end

  def valid_hcl?
    /^#[0-9a-f]{6}/.match?(hcl)
  end

  def valid_iyr?
    num_digits?(iyr, 4) && between?(2010, 2020, iyr)
  end

  def valid_eyr?
    num_digits?(eyr, 4) && between?(2020, 2030, eyr)
  end

  def valid_pid?
    num_digits?(pid, 9)
  end

  def valid_byr?
    num_digits?(byr, 4) && between?(1920, 2002, byr)
  end

  def valid_hgt?
    return false unless /[0-9]+(cm|in)$/.match?(hgt)

    end_num = hgt.length - 2

    if hgt.include?('cm')
      return false unless between?(150, 193, hgt[0, end_num])
    else
      return false unless between?(59, 76, hgt[0, end_num])
    end

    true
  end

  def valid_ecl?
    %w[amb blu brn gry grn hzl oth].include?(ecl)
  end

  def num_digits?(str, num)
    /^[0-9]{#{num}}$/.match?(str)
  end

  def between?(min, max, str)
    min <= str.to_i && str.to_i <= max
  end
end

input = Reader.new(path: 'input_files/sample_input_four.txt').split_on_double_newlines
puts PassportChecker.new(passports: input).count_valid_passports

input = Reader.new(path: 'input_files/input_four.txt').split_on_double_newlines
puts PassportChecker.new(passports: input).count_valid_passports


# passport = Passport.new(hcl: '#ab3de1', iyr: 'asdf', eyr: 'sadfio', ecl: 'amb', pid: '', byr: '', hgt: '72cm')
# p passport.valid_hcl?
# p passport.valid_hgt?


