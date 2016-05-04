require 'database_cleaner'
require 'sms_carrier/test_carrier'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    SmsCarrier::TestCarrier.deliveries.clear
  end

  config.after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
