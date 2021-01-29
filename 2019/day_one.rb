class FuelTotaler
  attr_reader :mods

  def initialize(mods)
    @mods = mods
  end

  def total_fuel
    mods.map do |mod|
      FuelCalculator.new(mod).calculate_fuel
    end.sum()
  end

  class FuelCalculator
    attr_reader :mod

    def initialize(mod)
      @mod = mod.to_i
    end

    def calculate_fuel
      (mod / 3).floor - 2
    end
  end
end

class FileReader
  attr_reader :filepath

  def initialize(filepath)
    @filepath = filepath
  end

  def read
    File.readlines(filepath)
  end
end


filelines = FileReader.new("./input_day_one.txt").read

total = FuelTotaler.new(filelines).total_fuel

puts total
