require 'spec_helper'
#require '../dummy/app/components/categories'

describe Categories do
  fixtures :books, :categories

  it "should get root records" do
    cats = Categories.new
    data = cats.get_records({id:'root'})
    data.count.should_not eq(0)
  end
end