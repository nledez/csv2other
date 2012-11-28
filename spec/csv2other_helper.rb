module Csv2otherSpecHelper
  def diff_file(dest, reference)
    File.read(dest).should == File.read(reference)
  end
end