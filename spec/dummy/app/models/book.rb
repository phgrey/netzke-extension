class Book < ActiveRecord::Base
  attr_accessible :on_sell, :presence, :price, :title, :category_id
end
