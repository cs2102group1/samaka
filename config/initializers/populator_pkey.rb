Populator::Factory.class_eval do
  def last_id_in_database
    0
  end
end

Populator::Record.class_eval do
  def initialize(model_class, id)
    @attributes = { "id" => id }
    @columns = model_class.column_names
    @columns.each do |column|
      case column
      when 'created_at', 'updated_at'
        @attributes[column.to_sym] = Time.now
      when 'created_on', 'updated_on'
        @attributes[column.to_sym] = Date.today
      when model_class.inheritance_column
        @attributes[column.to_sym] = model_class.to_s
      end
    end
  end
end
