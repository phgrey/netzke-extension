require 'active_record/errors'

class Netzke::Extension::ActiveRecordAdapter < Netzke::Basepack::DataAdapters::ActiveRecordAdapter

  #this is needed while https://github.com/netzke/netzke-basepack/pull/137 is pending
  def set_record_value_for_attribute(r, a, v, role = :default)
    v = v.to_time_in_current_zone if v.is_a?(Date) # convert Date to Time

    if a[:setter]
      a[:setter].call(r, v)
    elsif r.respond_to?("#{a[:name]}=") && attribute_mass_assignable?(a[:name], role)
      r.send("#{a[:name]}=", v)
    elsif association_attr?(a)
      split = a[:name].to_s.split(/\.|__/)
      if a[:nested_attribute]
        # We want:
        #     set_value_for_attribute({:name => :assoc_1__assoc_2__method, :nested_attribute => true}, 100)
        # =>
        #     r.assoc_1.assoc_2.method = 100
        split.inject(r) { |r,m| m == split.last ? (r && r.send("#{m}=", v) && r.save) : r.send(m) }
      else
        if split.size == 2
          # search for association and assign it to r
          assoc = @model_class.reflect_on_association(split.first.to_sym)
          if assoc
            if assoc.macro == :has_one
              if attribute_mass_assignable?(split.first, role) || attribute_mass_assignable?(assoc.foreign_key, role)
                assoc_instance = begin
                  assoc.klass.find(v)
                rescue ActiveRecord::RecordNotFound
                  nil
                end
                r.send "#{assoc.name}=", assoc_instance
                r.save
              end
            else

              # set the foreign key to the passed value
              # not that if a negative value is passed, we reset the association (set it to nil)
              r.send("#{assoc.foreign_key}=", v.to_i < 0 ? nil : v) if attribute_mass_assignable?(assoc.foreign_key, role)
            end
          else
            logger.debug "Netzke::Basepack: Association #{assoc} is not known for class #{@data_class}"
          end
        end
      end
    end
  end

  #there is a missprint - @model_class.reflect_on_association requires Symbol, not string
  def get_assoc_property_type assoc_name, prop_name
    if prop_name && assoc=@model_class.reflect_on_association(assoc_name.to_sym)
      assoc_column = assoc.klass.columns_hash[prop_name.to_s]
      assoc_column.try(:type)
    end
  end


  #This is a stub for the requests, where filters are set not by FilterFeatures, but
  #directly to store
  # parent takes String like "[{"type":"numeric","comparison":"eq","value":145588430,"field":"country_id"}]"
  # we will provide [{property:country_id, value:14558430}]
  def apply_column_filters(relation, column_filter)
    if column_filter.is_a? Array
      column_filter= column_filter.map{|f|
        {'comparison'=>'eq', 'value' => f[:value], 'field' => f[:property]}
      }.to_json
    end
    super
  end

  # Returns association and association method for a column
  # we do override it bc we do want to operate multi-level (>2) nesting
  def assoc_and_assoc_method_for_attr(column_name)
    assoc_names = column_name.split('__')
    assoc_method = assoc_names.pop
    return [nil, nil] if assoc_names.count == 0
    assoc = nil
    assoc_klass = @model_class.clone
    assoc_names.each do |method|
      assoc = assoc_klass.reflect_on_association(method.to_sym)
      assoc_klass = assoc.klass
    end
    [assoc, assoc_method]
  end

  # we do override this bc we do need to correct show 3-rd level nesting
  def record_value_for_attribute(r, a, through_association = false)
    v = if a[:getter]
          a[:getter].call(r)
        elsif r.respond_to?("#{a[:name]}")
          r.send("#{a[:name]}")
        elsif association_attr?(a)
          split = a[:name].to_s.split(/\.|__/)

          if through_association
            split.inject(r) do |r,m| # Do we *really* need to descend deeper than 1 level?
              return nil if r.nil?
              if r.respond_to?(m)
                r.send(m)
              else
                logger.debug "Netzke::Basepack: Wrong attribute name: #{a[:name]}" unless r.nil?
                nil
              end
            end
          else
            assoc, method = assoc_and_assoc_method_for_attr a[:name]
            split.pop 2
            val = split.inject(r) do |r,m|
              return nil if r.nil?
              if r.respond_to?(m)
                r.send(m)
              else
                logger.debug "Netzke::Basepack: Wrong attribute name: #{a[:name]}" unless r.nil?
                nil
              end
            end
            val && val.send("#{assoc.options[:foreign_key] || assoc.name.to_s.foreign_key}")
          end
        end

    # a work-around for to_json not taking the current timezone into account when serializing ActiveSupport::TimeWithZone
    v = v.to_datetime.to_s(:db) if [ActiveSupport::TimeWithZone].include?(v.class)

    v
  end

end