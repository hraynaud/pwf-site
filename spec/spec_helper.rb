
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  FakeWeb.allow_net_connect = false
  FakeWeb.allow_net_connect = %r[^https?://127\.0\.0\.1.+|^https?://localhost/.+]

  config.filter_run_excluding :focus => :payment
  config.mock_with :rspec

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.javascript_driver = :selenium_chrome

  Capybara.configure do |config|
    config.default_max_wait_time = 10 # seconds
    config.default_driver        = :selenium
  end
end

def suppress_log_output
  allow(STDOUT).to receive(:puts) # this disables puts
  logger = double('Logger').as_null_object
  allow(Logger).to receive(:new).and_return(logger)
end
