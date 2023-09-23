# frozen_string_literal: true

# This class will log the requested ActiveRecord table data.
class TableInfo < ActiveInteraction::Base
  interface :model, methods: %i[columns]
  string :output, default: 'log'
  array :columns, default: nil

  PERMITTED_OUTPUT_OPTIONS = %w[log].freeze
  DEFAULT_COLUMNS_TO_DISPLAY = %w[name null default type sql_type default_function comment].freeze

  def execute
    puts log_table_info if output == 'log'
  end

  def validate
    return errors.add(:model, "param 'model' is required.") if model.nil?

    validate_model

    validate_output
  end

  def validate_model
    return if model.ancestors.include?(ActiveRecord::Base)

    errors.add(:model, "Param 'model' must be a ActiveRecord::Base descendant.")
  end

  def validate_output
    if output.nil?
      errors.add(:output, "Param 'output' is required.")
    elsif !PERMITTED_OUTPUT_OPTIONS.include?(output)
      errors.add(:output, "Param 'output_format' not in #{PERMITTED_OUTPUT_OPTIONS.inspect}")
    end
  end

  def valid?
    errors.clear

    validate

    errors.empty?
  end

  def invalid?
    !valid?
  end

  def log_table_info
    puts table_info
  end

  def table_info
    Text::Table.new(
      head: columns_headers,
      rows: map_columns.map { |c| columns_headers.map { |key| c[key] } }
    ).to_s
  end

  def columns_headers
    @columns_headers ||= columns || DEFAULT_COLUMNS_TO_DISPLAY
  end

  def map_columns
    @model.columns.map do |col|
      data = col.as_json

      col.sql_type_metadata.as_json.each_key do |key|
        data[key] = col.sql_type_metadata.send(key)
      end

      data.with_indifferent_access
    end
  end
end
