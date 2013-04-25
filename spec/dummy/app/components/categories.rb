class Categories < Netzke::Extension::TreeGridPanel

  def configure(c)
    c.model = 'Category'
    c.column = {:name => :title}
    c.pri = :class_plus_id
    super
  end

  def js_configure c
    c.cls = 'grid-without-headers'
    super
  end

  # Retrieves all children for a node
  #
  # @param [Hash] params
  # @return [Array] array of records
  def get_records(params)
    if params[:id].nil? || params[:id] == 'root'
      Category.where(:parent_id => nil)
    else  params[:id] =~ /Category-(\d+)/
      cat = Category.find $1
      cat.lft == cat.rgt-1 ? Book.where(:category_id => cat.id)
        : Category.where(:parent_id => cat.id)
    end
  end


  # Leaf or not?
  def leaf?(r)
    r.is_a?(Book)
  end

  # Unique identifier for a record
  def class_plus_id(r)
    "#{r.class}-#{r.id}"
  end
end