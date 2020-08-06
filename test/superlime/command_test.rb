require 'minitest/autorun'
require 'superlime'

module Superlime
  class CommandTest < MiniTest::Test
    TestCommand = Class.new(Superlime::Command) do
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def call
        if params[:fail]
          broadcast(:failed, params[:fail])
        elsif params[:success]
          broadcast(:succeeded, params[:success])
        end
      end
    end

    def test_fail_called
      case TestCommand.call(fail: 'it failed')
      in failed: String => error_msg then assert_equal('it failed', error_msg)
      else flunk('pattern match failed')
      end
    end

    def test_success_called_with_simple_match
      case TestCommand.call(success: { result:  10 })
      in succeeded: result then assert_equal({ result: 10 }, result)
      else flunk('pattern match failed')
      end
    end

    def test_success_called_with_complex_match
      case TestCommand.call(success: { result:  10 })
      in succeeded: { result: Numeric => result } then assert_equal(10, result)
      else flunk('pattern match failed')
      end
    end
  end
end