require 'pg'
require_relative './booking'
require_relative './space'
require_relative './user'

class Database
  class << self
    def init(dbname)
      @connection = PG.connect dbname: dbname
      [Booking, Space, User].each(&:setup_prepared_statements)
    end
    attr_reader :connection
  end
end