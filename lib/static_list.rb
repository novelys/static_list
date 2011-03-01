require "active_support"

if ActiveSupport::VERSION::MAJOR < 3
  require "core_ext/concern"
end

class Hashit
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
    end
  end
end

module StaticList
  module Validate
    extend ActiveSupport::Concern
    
    module ClassMethods
      # Method to validate in the receiving model that the value received is included in the static list model.
      # For example :
      # with_options(:allow_blank => true) do |options|
      #   options.validate_static_list_value :hair_color,          HairColor
      #   options.validate_static_list_value :ethnicity,           Ethnicity
      #   options.validate_static_list_value :sex,                 Sex
      # end
      def validates_static_list_value(attribute, model, options = {})
        options.merge!(:in => model.static_list_codes.map { |el| el[1] })
        validates_inclusion_of attribute, options
      end
    end
  end
  
  module Model
    extend ActiveSupport::Concern

    included do
      cattr_accessor :static_list_codes
    end
    
    module ClassMethods
      # Returns all elements of the static list
      def all
        static_list_codes.map{|x| Hashit.new(Hash[*["name", I18n.t("#{self.to_s.demodulize.underscore}.#{x.first.to_s}"), "id", x.last]])}
      end

      # Method to declare the static list in the static list model.
      def static_list(list)
        self.static_list_codes = list
      end
      
      # Returns the symbol associated with the code in parameter.
      #
      # For example : HairColor.code_to_sym(0) # => :white
      #
      def code_to_sym(code)
        static_list_codes.find { |el| el[1] == code }[0]
      end
      
      # Returns the code associated with the symbol in parameter.
      #
      # For example : HairColor.sym_to_code(:white) # => 0
      #
      def sym_to_code(sym)
        static_list_codes.find {|el| el[0] == sym }[1]
      end
      
      def t_key_from_code(code)
        "#{self.to_s.demodulize.underscore}.#{self.code_to_sym(code)}"
      end
      
      def static_codes
        static_list_codes.map{ |e| e[0] }
      end
      
      def static_keys
        static_list_codes.map{ |e| e[1] }
      end
    end
  end
  
  module Helpers
    # Localizes a static code
    # For example :
    # t_static_list(@user.hair_color, HairColor)
    #
    # will read the key hair_color.white
    #
    def t_static_list(code, static_object)
      return unless code
      t(static_object.t_key_from_code(code))
    end

    # Localizes all the static codes for select options helper
    #
    # Example :
    # f.select :hair_color, static_list_select_options(HairColor)
    #
    def static_list_select_options(static_object)
      static_object.static_list_codes.map { |code| [t_static_list(code[1], static_object), code[1]] }
    end
  end
end
