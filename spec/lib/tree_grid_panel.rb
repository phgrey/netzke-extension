=begin
require 'spec_helper'

describe Netzke::Extension::TreeGridPanel do
  it "should return data for a named element" do
    element_data = PeriodicTable.lookup('oxygen')
    element_data.should_not be_nil
    element_data.symbol.should == 'O'
    element_data.atomic_weight.should == '15.9994'
  end
end
=end
