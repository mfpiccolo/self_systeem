module SelfSysteem
  class InstanceVariablesBuilder
    include ActionView::Helpers::NumberHelper

    attr_reader :controller, :relevant_instance_varaibles, :instance_variable_objects

    def initialize(controller)
      @controller = controller
    end

    def call
      build_variables
      self
    end

    def self.call(controller)
      new(controller).call
    end

    private

    def build_variables
      @relevant_instance_varaibles = controller
        .instance_variable_names.reject {|v| v[/@_/] || v == "@marked_for_same_origin_verification"}
      @instance_variable_objects = {}
      relevant_instance_varaibles.each do |v|
        iv_val = controller.instance_variable_get(v)
        if iv_val.class.name.match(/ActiveRecord::AssociationRelation|ActiveRecord::Associations::CollectionProxy/)
          instance_variable_objects.merge!(v.to_s => { })
          iv_val.each do |o|
            instance_variable_objects[v.to_s].merge!(o.attributes.select {|k, v| k.to_s.match(/^id|_id/)})
          end
        elsif iv_val.respond_to?(:attributes)
          instance_variable_objects.merge!({ v.to_s => iv_val.attributes.select {|k, v| k.to_s.match(/^id|_id/)} })
        elsif iv_val.present? && iv_val.class.ancestors.select {|c| c.to_s.match(/ActiveModel|ActiveRecord/)}.present? && iv_val.is_a?(Symbol) != true
          instance_variable_objects.merge!({ v.to_s => slice_hash(JSON.parse(iv_val.to_json), /^id|_id/) })
        elsif iv_val.respond_to?(:instance_values)
          instance_variable_objects.merge!({ v.to_s => iv_val.instance_values.select {|k, v| k.to_s.match(/^id|_id/)} })
        else
          instance_variable_objects.merge!({ v.to_s => iv_val.to_s })
        end
      end
    end

    def transform_hash(original, options={}, &block)
      original.inject({}){|result, (key,value)|
        value = if (options[:deep] && Hash === value)
                  transform_hash(value, options, &block)
                else
                  value
                end
        block.call(result,key,value)
        result
      }
    end

    def slice_hash(hash, regex)
      transform_hash(hash, :deep => true) {|hash, key, value|
        hash[key] = value if (value.is_a?(Hash) || key.to_s.match(regex) )
      }
    end

  end
end
