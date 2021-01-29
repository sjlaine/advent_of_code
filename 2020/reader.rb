class Reader
  attr_reader :path

  def initialize(path:)
    @path = path
  end

  def values
    File.open(self.path).readlines.map(&:chomp)
  end

  def split_on_double_newlines
    File.read(path).split("\n\n")
  end
end
