require 'csv2other/version'
require 'csv'
require 'erb'

class Csv2other
  attr_reader :content

  def initialize
    @content = {}
  end

  def parse(csv_filename, key)
    key_symbol = key.to_sym
    CSV.foreach(csv_filename, :col_sep =>';', :headers => true, :header_converters => :symbol) do |line|
      current_key = line[key_symbol]
      @content[current_key] = line
    end
  end

  def list
    @content.keys
  end

  def load_template(template_filename)
    @template = template_filename
  end

  def each
    @content.each do |k, v|
      yield k, v
    end
  end

  def convert_with_key(key)
    @e = @content[key]
    template = File.open(@template).readlines.join
    ERB.new(template).result(self.get_binding)
  end

  def convert(value)
    @e = value
    template = File.open(@template).readlines.join
    ERB.new(template).result(self.get_binding)
  end

  # Method needed for ERB
  # Expose private binding() method.
  # http://www.stuartellis.eu/articles/erb/
  def get_binding
    binding()
  end
end
