require 'dry/validation/rule'

module Dry
  module Validation
    class Schema
      class Key
        attr_reader :name, :rules

        def initialize(name, rules, &block)
          @name = name
          @rules = rules
        end

        private

        def method_missing(meth, *args, &block)
          key_rule = [:key, [name, [:predicate, [meth, args]]]]

          if block
            val_rule = yield(Value.new(name))

            rules <<
              if val_rule.is_a?(Array)
                Definition::Rule.new([:and, [key_rule, [:set, [name, val_rule.map(&:to_ary)]]]])
              else
                Definition::Rule.new([:and, [key_rule, val_rule.to_ary]])
              end
          else
            Definition::Rule.new(key_rule)
          end
        end

        def respond_to_missing?(meth, _include_private = false)
          true
        end
      end
    end
  end
end
