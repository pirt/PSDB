ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
  begin
    # self.emulate_integers_by_column_name = true
    # self.emulate_dates_by_column_name = true
    # self.emulate_booleans_from_strings = true
    # self.string_to_date_format = "%d.%m.%Y"
    # self.string_to_time_format = "%d.%m.%Y %H:%M:%S"
    self.default_sequence_start_value = "1 NOCACHE INCREMENT BY 1" # Udo: set start index to 1 with no gaps (default is 10000)
  rescue
    nil
  end
end

