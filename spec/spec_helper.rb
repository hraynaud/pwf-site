require 'rubygems'

prefork = lambda {

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rails'
  require 'capybara/rspec'
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|

    FakeWeb.allow_net_connect = false
    FakeWeb.allow_net_connect = %r[^https?://127\.0\.0\.1.+|^https?://localhost/.+]

    config.filter_run_including :focus => "aep"
    config.filter_run_excluding :focus => :payment
    config.mock_with :rspec
    config.infer_base_class_for_anonymous_controllers = false

    config.include StepHelpers
    config.include StripeHelper

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean_with(:truncation)
      StripeHelper.setup
    end

    config.before(:each) do
      FactoryGirl.create(:season)
      FactoryGirl.create(:prev_season)
      DatabaseCleaner.start
      @season = FactoryGirl.create(:season)
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end

}

#end
each_run = lambda {}

if defined?(Zeus)
  prefork.call
  $each_run = each_run
  class << Zeus.plan
    def after_fork_with_test
      after_fork_without_test
      $each_run.call
    end
    alias_method_chain :after_fork, :test
  end
elsif ENV['spork'] || $0 =~ /\bspork$/
  require 'spork'
  Spork.prefork(&prefork)
  Spork.each_run(&each_run)
else
  prefork.call
  each_run.call
end


