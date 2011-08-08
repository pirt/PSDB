begin
ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
    # Udo: set start index to 1 with no gaps (default is 10000)
    self.default_sequence_start_value = "1 NOCACHE INCREMENT BY 1"
    if ['development', 'test', 'production'].include? Rails.env
      self.cache_columns = true
    end
  end
end
rescue
  nil
end

