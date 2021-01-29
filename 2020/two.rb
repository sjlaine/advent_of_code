require_relative 'reader.rb'

class PolicyReader
  attr_reader :policies

  def initialize(policy_strings:)
    @policies = sanitize_policies(policy_strings)
  end

  def sanitize_policies(policy_strings)
    policy_strings.map do |str|
      str.tr(':', '').split(' ')
    end
  end

  def check_policies
    self.policies.map do |policy|
      parser = PolicyParser.new(policy: policy)
      frequency_range = parser.frequency_range
      character = parser.character
      password = parser.password

      valid = PasswordChecker
                .new(frequency_range: frequency_range, character: character, password: password)
                .valid_password?

      puts valid
      valid ? 1 : 0
    end.reduce(:+)
  end

  class PolicyParser
    attr_reader :policy

    def initialize(policy:)
      @policy = policy
    end

    def frequency_range
      self.policy.first.split('-').map(&:to_i)
    end

    def character
      self.policy[1]
    end

    def password
      self.policy[2]
    end
  end
end

class PasswordChecker
  attr_reader :min_freq, :max_freq, :first_idx, :second_idx, :character, :password

  def initialize(frequency_range:, character:, password:)
    @min_freq = frequency_range[0]
    @max_freq = frequency_range[1]

    @first_idx = self.min_freq - 1
    @second_idx = self.max_freq - 1
    @character = character
    @password = password
  end

  def count_frequency
    pw_without_char = self.password.tr(self.character, '')
    self.password.length - pw_without_char.length
  end

  # def valid_password?
  #   count_frequency >= self.min_freq && count_frequency <= self.max_freq
  # end

  def valid_password?
    first = self.password[self.first_idx] == self.character
    second = self.password[self.second_idx] == self.character

    if first
      second ? false : true
    elsif second
      true
    else
      false
    end
  end
end

strings = [
'1-3 a: abcde',
'1-3 b: cdefg',
'2-9 c: ccccccccc'
]

solution = PolicyReader.new(policy_strings: strings).check_policies
p solution

strings = Reader.new(path: 'input_files/input_two.txt').values
solution = PolicyReader.new(policy_strings: strings).check_policies
p solution

# parser = PolicyParser.new(policy: policies[2])
# frequency_range = parser.frequency_range
# character = parser.character
# password = parser.password
#
# checker = PasswordChecker.new(frequency_range: frequency_range, character: character, password: password)
# p checker.valid_password?
