class Database
  class << self
    def init(dbname)
      @connection = PG.connect dbname: dbname
    end
    attr_reader :connection
  end
end