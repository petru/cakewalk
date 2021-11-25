require "cakewalk/sasl/diffie_hellman"
require "cakewalk/sasl/plain"
require "cakewalk/sasl/dh_blowfish"

module Cakewalk
  # SASL is a modern way of authentication in IRC, solving problems
  # such as transmitting passwords as plain text (see the DH-BLOWFISH
  # mechanism) and fully identifying before joining any channels.
  #
  # Cakewalk automatically detects which mechanisms are supported by the
  # IRC network and uses the best available one.
  #
  # # Supported Mechanisms
  #
  # - {SASL::DH_Blowfish DH-BLOWFISH}
  # - {SASL::Plain PLAIN}
  #
  # # Configuration
  # In order to use SASL one has to set the username and password
  # options as follows:
  #
  #     configure do |c|
  #        c.sasl.username = "foo"
  #        c.sasl.password = "bar"
  #     end
  #
  # @note All classes and modules in this module are for internal use by
  #   Cakewalk only.
  #
  # @api private
  # @since 2.0.0
  module SASL
  end
end
