require 'rack/test'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'
require_relative '../config/environment'
require_relative '../config/application'

Sequel::Migrator.run(DB, File.join(BASE_PATH, 'db/migrations'))

Dir['./spec/support/**/*.rb'].each { |f| require f }
RSpec.configure do |config|
  config.include Request::Helpers
  config.include Response::Helpers

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

require 'api/base'
