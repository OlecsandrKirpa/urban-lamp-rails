# frozen_string_literal: true

RSpec::Matchers.define :have_input do |input_name| # rubocop:disable Metrics/BlockLength
  # ###################################
  # Main matcher. Will call all the methods below.
  # ###################################

  match do |klass|
    @klass = klass.is_a?(Class) ? klass : klass.class
    unless @klass.ancestors.include?(ActiveInteraction::Base)
      raise ArgumentError, 'The given class is not an ActiveInteraction.'
    end

    @input_name = input_name.to_sym

    @input = @klass.filters[@input_name]

    check_input_presence &&
      check_input_type &&
      check_default_value_presence &&
      check_default_value &&
      check_options
  end

  # ###################################
  # Methods and utils to define the matchers
  # ###################################
  @with_default_value_proc = proc do |default_value = '_dont_check_value_itself_but_only_presence'|
    is_optional!
    # next/break ?
    next if default_value == '_dont_check_value_itself_but_only_presence'

    @check_default_value = true
    @default_value = default_value
  end

  @of_type_proc = proc do |input_type|
    @check_input_type = true

    case input_type
    when Symbol, String, Class
      @input_type = input_type.to_s.downcase
    else
      raise ArgumentError, 'The given input type is not supported.'
    end

    unless %w[
      object record symbol
      interface string integer
      float decimal boolean date
      date_time time file array hash
    ].include?(@input_type)
      puts "The given input type is not supported: #{@input_type}"
      # raise ArgumentError, 'The given input type is not supported.'
    end
  end

  @with_option_proc = proc do |option_name, option_value|
    if !option_name.is_a?(String) && !option_name.is_a?(Symbol)
      raise ArgumentError, 'The given option name is not a String or Symbol.'
    end

    @check_options = true
    @options ||= {}
    @options[option_name] = option_value
  end

  @with_options_proc = proc do |options|
    @check_options = true
    puts "Redefining options: #{@options} with #{options}" unless @options.nil?

    raise ArgumentError, 'The given options are not a Hash.' unless options.is_a?(Hash)

    @options = options
  end

  def is_mandatory!
    @check_default_value_presence = true
    @default_value_presence = false
  end

  def is_optional!
    @check_default_value_presence = true
    @default_value_presence = true
  end

  def is_mandatory?
    @check_default_value_presence && @default_value_presence == false
  end

  def is_optional?
    @check_default_value_presence && @default_value_presence == true
  end

  # ###################################
  # Matchers
  # ###################################

  chain(:mandatory)             { is_mandatory! }
  chain(:without_default_value) { is_mandatory! }
  chain(:without_default)       { is_mandatory! }
  chain(:required)              { is_mandatory! }

  chain(:optional)              { is_optional! }

  chain(:with_default_value, &@with_default_value_proc)
  chain(:with_default, &@with_default_value_proc)

  chain(:of_type, &@of_type_proc)

  chain(:with_option, &@with_option_proc)

  chain(:with_options, &@with_options_proc)

  # ###################################
  # Matcher utils
  # ###################################

  failure_message do
    errors = []
    errors << "Does not exist input called #{@input_name.inspect}" unless check_input_presence
    unless @input.nil?
      errors << "Type mismatch #{@input_type.inspect}" unless check_input_type
      errors << "Options mismatch: #{@different_options.values.join('; ')}" unless check_options

      if @input.default? && !check_default_value
        errors << "Default value mismatch: expected #{@default_value.inspect}, but was #{@input.default}"
      end

      unless check_default_value_presence
        errors << 'isn\'t optional' if is_optional?
        errors << 'isn\'t mandatory' if is_mandatory?
      end
    end
    "Expected #{@klass} to #{spec_description}.\n#{errors.join("\n")}"
    # errors.join("\n")
  end

  description do
    spec_description
  end

  def spec_description
    a = 'have'
    a += ' mandatory' if is_mandatory?
    a += ' optional' if is_optional?
    a += " input #{@input_name.inspect}"
    a += " of type #{@input_type}" if @check_input_type
    a += " #{@default_value}" if is_mandatory? && @check_default_value
    a += " with options #{@options}" if @check_options
    a
  end

  # ###################################
  # Methods to validate the spec
  # ###################################

  def check_options
    return true unless @check_options

    @different_options = {}
    @options.each do |option_name, option_value|
      next if @input.options[option_name] == option_value

      @different_options[option_name] = "#{option_name.inspect} expected to be #{option_value.inspect}, but was #{@input.options[option_name].inspect}"
    end

    @different_options.empty? ? true : false
  end

  def check_input_presence
    @input.present? && @input.is_a?(ActiveInteraction::Filter)
  end

  def check_input_type
    return true unless @check_input_type

    if @input_type == 'interface'
      return @input.is_a?(ActiveInteraction::InterfaceFilter)
    end

    if @input_type.is_a?(String)
      return @input.database_column_type.to_s == @input_type
    end

    false
  end

  def check_default_value_presence
    return true unless @check_default_value_presence

    @input.default? == @default_value_presence
  end

  def check_default_value
    return true unless @check_default_value

    @input.default == @default_value
  end
end
