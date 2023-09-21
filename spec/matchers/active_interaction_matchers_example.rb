# frozen_string_literal: true

# Class useful to test active_interaction_matchers
class ActiveInteractionMatchersExample < ActiveInteraction::Base
  string :mandatory_string
  string :optional_string, default: 'default value'

  integer :mandatory_integer
  integer :optional_integer, default: 1

  float :mandatory_float
  float :optional_float, default: 1.0

  decimal :mandatory_decimal
  decimal :optional_decimal, default: 1.0

  boolean :mandatory_boolean
  boolean :optional_boolean, default: true

  date :mandatory_date
  date :optional_date, default: Date.today

  time :mandatory_time
  time :optional_time, default: Time.now
end
