class Category < ActiveRecord::Base
  attr_accessible :lft, :parent_id, :rgt, :title

  has_many :books
end
