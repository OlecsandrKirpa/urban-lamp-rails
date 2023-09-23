# frozen_string_literal: true

# Abstract class for all models
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # ##########################################
  # Class methods
  # ##########################################
  class << self
    def log_table_info(args = {})
      puts TableInfo.run!(args.merge(model: self))
    end
  end

  scope :random_order, -> { order(Arel.sql('RANDOM()')) }
end
