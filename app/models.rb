require 'sequel'
require 'pg'
require 'logger'
require 'bcrypt'
require 'securerandom'
require 'json'
require 'base64'

$console = ENV['RACK_ENV'] == 'development' ? Logger.new(STDOUT) : nil
DB = Sequel.connect(
  ENV['MOTH_DB'] || 'postgres://localhost/moth',
  logger: $console,
  test: true
)

DB.sql_log_level = :debug
DB.extension(:pagination)
DB.extension(:pg_array, :pg_json)
DB.extension(:connection_validator)

DB.pool.connection_validation_timeout = 300

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :json_serializer

require 'models/user'
require 'models/log'
require 'models/token'
require 'models/cookie'
require 'models/application'
require 'models/helpers/model_helpers'
require 'models/mock_gmail'
