require 'spec_helper'

describe Book do

  fixtures :books


  it 'should not be epmpty' do
    Book.all.count.should_not eq(0)
  end
end
