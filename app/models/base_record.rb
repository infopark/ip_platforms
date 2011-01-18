module BaseRecord

  def self.included(base)
    base.extend(ClassMethods)
    base.strip_text_fields
  end

  module ClassMethods

    def strip_text_fields
      before_validation do |record|
        record.fields_to_strip.each do |field|
          value = record[field]
          if !value.nil? && value.respond_to?(:strip)
            value = value.strip
            value = nil if value.size == 0
            record[field] = value
          end
        end
      end
    end

  end

  def fields_to_strip
    attributes.keys
  end

end
