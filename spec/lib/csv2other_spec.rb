require 'csv2other_helper'
require 'csv2other'

describe "Csv2other" do
  include Csv2otherSpecHelper

  it "Can load data and create target file" do
    converter01 = Csv2other.new
    converter01.parse("spec/data/case01/01-input.csv", "host")
    converter01.content.should be_an_instance_of(Hash)
    converter01.list.should == [ "host1", "host2", "host3" ]

    converter01.load_template("spec/data/case01/02-template.cli.erb")

    filename = 'tmp/01-03-expected.cli'
    destination = File.open(filename, "w")
    converter01.each do |k, e|
      destination.puts converter01.convert_with_key(k)
    end
    destination.close

    # diff_file(filename, 'spec/data/case01/03-expected.cli')
  end
end
