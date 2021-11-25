require "cakewalk/configuration"

module Cakewalk
  class Configuration
    # @since 2.0.0
    class Plugins < Configuration
      KnownOptions = [:plugins, :prefix, :suffix, :options]

      def self.default_config
        {
          :plugins => [],
          :prefix  => /^!/,
          :suffix  => nil,
          :options => Hash.new {|h,k| h[k] = {}},
        }
      end

      def load(new_config, from_default = false)
        _new_config = {}
        new_config.each do |option, value|
          case option
          when :plugins
            _new_config[option] = value.map{|v| Cakewalk::Utilities::Kernel.string_to_const(v)}
          when :options
            _value = self[:options]
            value.each do |k, v|
              k = Cakewalk::Utilities::Kernel.string_to_const(k)
              v = self[:options][k].merge(v)
              _value[k] = v
            end
            _new_config[option] = _value
          else
            _new_config[option] = value
          end
        end

        super(_new_config, from_default)
      end
    end
  end
end
