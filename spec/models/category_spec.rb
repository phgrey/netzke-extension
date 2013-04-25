require 'spec_helper'

describe Category do
  fixtures :categories


  it 'should not be epmpty' do
    Category.count.should_not eq(0)
  end
end
