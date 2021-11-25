if ENV["SIMPLECOV"]
  begin
    require 'simplecov'
    SimpleCov.start
  rescue LoadError
  end
end

unless Object.const_defined? 'Cakewalk'
  $:.unshift File.expand_path('../../lib', __FILE__)
  require 'cakewalk'
end

require 'minitest/autorun'

class TestCase < MiniTest::Test
  def self.test(name, &block)
    define_method("test_" + name, &block) if block
  end
end
