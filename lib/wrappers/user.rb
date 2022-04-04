class User
  attr_reader :username, :first_name, :last_name, :email, :telephone

  def initialize(username, first_name, last_name, email, telephone)
    @username = username
    @first_name = first_name
    @last_name = last_name
    @email = email
    @telephone = telephone
  end

  class << self

    def setup_prepared_statements
      Database.connection.prepare('user_by_username', 'SELECT * FROM users WHERE username=$1')
    end

    def _users_from_query(query)
      query.map { |it| User.new(it[:username], it[:first_name], it[:last_name], it[:email], it[:telephone]) }
    end

    def get_by_username(username)
      _users_from_query(Database.connection.exec_prepared('user_by_username', [username]))[0]
    end
  end
end