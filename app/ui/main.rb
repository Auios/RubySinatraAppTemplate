require_relative '../lib/constants'
require_relative '../lib/managers/database_manager'
require_relative 'server'

database_manager = DatabaseManager.new(Constants::Database::NAME)

unless database_manager.database_exists?(Constants::Database::NAME)
  database_manager.create_table(Constants::Tables::TEST)
end

Server.run!(
  bind: Constants::Server::BIND,
  port: Constants::Server::PORT,
  database_manager: database_manager
)
