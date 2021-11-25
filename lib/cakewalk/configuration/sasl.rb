require "cakewalk/configuration"
require "cakewalk/sasl"

module Cakewalk
  class Configuration
    # @since 2.0.0
    class SASL < Configuration
      KnownOptions = [:username, :password, :mechanisms]

      def self.default_config
        {
          :username => nil,
          :password => nil,
          :mechanisms => [Cakewalk::SASL::DH_Blowfish, Cakewalk::SASL::Plain]
        }
      end
    end
  end
end
