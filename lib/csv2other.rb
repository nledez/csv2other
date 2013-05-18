require 'csv2other/version'
require 'csv'
require 'erb'
require 'nokogiri'

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
    @template_filename = template_filename
    @template = File.open(@template_filename).readlines.join
  end

  def load_xsd(xsd_path)
    @xsd_path = xsd_path
    @xsddoc = Nokogiri::XML(File.read(xsd_path), xsd_path)
    @xsd = Nokogiri::XML::Schema.from_document(@xsddoc)
  end

  def each
    @content.each do |k, v|
      yield k, v
    end
  end

  def convert_with_key(key)
    @e = @content[key]
    render
  end

  def convert(value)
    @e = value
    render
  end

  def render(my_binding = binding)
    content = ERB.new(@template).result(my_binding)
    unless @xsd.nil?
      @xsd.validate(Nokogiri::XML(content)).each do |error|
        puts error.message
        raise error
      end
    end
    content
  end
end
