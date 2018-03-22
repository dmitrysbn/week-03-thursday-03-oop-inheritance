require 'minitest/autorun'
require 'minitest/pride'
require './multilinguist.rb'

class TestMultilinguist < MiniTest::Test

  def test_language_in_russia_returns_ru
    multilinguist = Multilinguist.new

    expected = 'fr'
    actual = multilinguist.language_in('France')

    assert_equal(expected, actual)
  end

end
