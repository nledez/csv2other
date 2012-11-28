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

    filename_key = 'tmp/01-03-expected-with-key.cli'
    destination = File.open(filename_key, "w")
    converter01.each do |k, e|
      @e = e
      destination.puts converter01.render(binding)
    end
    destination.close

    diff_file(filename_key, 'spec/data/case01/03-expected.cli')
  end

  it "Can create target file with value" do
    converter01 = Csv2other.new
    converter01.parse("spec/data/case01/01-input.csv", "host")

    converter01.load_template("spec/data/case01/02-template.cli.erb")

    filename_value = 'tmp/01-03-expected-with-value.cli'
    destination = File.open(filename_value, "w")
    converter01.each do |k, e|
      @e = e
      destination.puts converter01.render(binding)
    end
    destination.close

    diff_file(filename_value, 'spec/data/case01/03-expected.cli')
  end

  it "Can create target file without parameters" do
    converter01 = Csv2other.new
    converter01.parse("spec/data/case01/01-input.csv", "host")

    converter01.load_template("spec/data/case01/02-template.cli.erb")

    filename_value = 'tmp/01-03-expected-with-parameters.cli'
    destination = File.open(filename_value, "w")
    converter01.each do |k, e|
      @e = e
      destination.puts converter01.render(binding)
    end
    destination.close

    diff_file(filename_value, 'spec/data/case01/03-expected.cli')
  end

  it "Can generate separe files" do
    converter02 = Csv2other.new
    converter02.parse("spec/data/case02/01-case02.csv", "account")

    converter02.load_template("spec/data/case02/02-template.xml.erb")

    converter02.each do |k, e|
      @e = e
      filename_value = "tmp/02-#{k}.xml"
      destination = File.open(filename_value, "w")
      destination.puts converter02.render(binding)
      destination.close
    end

    converter02.list.each do |account|
      diff_file("tmp/02-#{account}.xml", "spec/data/case02/03-results/#{account}.xml")
    end
  end

  it "Can validate XML" do
    converter03 = Csv2other.new
    converter03.parse("spec/data/case03/01-case03.csv", "account")

    converter03.load_template("spec/data/case03/02-template.xml.erb")
    converter03.load_xsd("spec/data/case03/account.xsd")

    filename_value = "tmp/03-dummy.xml"
    destination = File.open(filename_value, "w")

    begin
      orig_stdout = $stdout.clone
      $stdout.reopen File.new('tmp/stdout.txt', 'w')

      expect do
        converter03.each do |k, e|
          @e = e
          destination.puts converter03.render(binding)
        end
      end.to raise_error(Nokogiri::XML::SyntaxError, "Element 'account': This element is not expected.")
    rescue Exception => e
      $stdout.reopen orig_stdout
      raise e
    ensure
      $stdout.reopen orig_stdout
    end

    destination.close
  end
end
