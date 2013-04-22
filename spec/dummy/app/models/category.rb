class Category < ActiveRecord::Base
  attr_accessible :lft, :parent_id, :rgt, :title
end
