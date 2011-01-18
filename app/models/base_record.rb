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

    def text_filter_conditions(filter_text, *name_columns)
      unless filter_text.blank?
        where = []
        name_columns.flatten.each do |column|
          where << sanitize_sql(["LOWER(#{table_name}.#{column}) like LOWER(?)",
                                 "%#{filter_text}%"])
        end
        where.empty? ? nil : "(#{where.join(' or ')})"
      else
        nil
      end
    end

    def multiword_text_filter_conditions(filter_text, *name_columns)
      words = filter_text.to_s.split(/\s+/).reject(&:blank?)
      if words.empty?
        nil
      else
        where = words.map {|w| text_filter_conditions(w, *name_columns)}.compact
        where.empty? ? nil : "(#{where.join(' and ')})"
      end
    end

  end

  def fields_to_strip
    attributes.keys
  end

end
