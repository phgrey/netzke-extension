require 'test/unit'
require 'netzke-extension'

class TestExtension < Test::Unit::TestCase
  def test_silly_example
    assert_equal 2+2, 4
  end

  def test_version_string
    assert_equal Netzke::Extension.version_string, "Version is #{Netzke::Extension::VERSION}"
  end
end