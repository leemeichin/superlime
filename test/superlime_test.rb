# frozen_string_literal: true

require "test_helper"

class SuperlimeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Superlime::VERSION
  end
end
