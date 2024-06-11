require "simplecov"
SimpleCov.start "rails" do
  add_filter "app/channels"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Get parallel tests to play nice with SimpleCov.
    parallelize_setup { |worker| SimpleCov.command_name("\#{SimpleCov.command_name}-\#{worker}") }
    parallelize_teardown { |worker| SimpleCov.result }

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Reset test states after each test.
    #
    # @return [void]
    def teardown
      super
      Mocktail.reset
    end
  end
end
