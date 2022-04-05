require 'pg'
require 'bcrypt'

class User
  attr_reader :username, :first_name, :last_name, :email, :telephone

  def initialize(username, first_name, last_name, email, telephone)
    @username = username
    @first_name = first_name
    @last_name = last_name
    @email = email
    @telephone = telephone
  end

  def password=(password)
    Database.connection.exec_prepared('user_update_password', [@username, BCrypt::Password.create(password)])
  end

  class << self

    def setup_prepared_statements
      Database.connection.prepare('user_by_username', 'SELECT * FROM users WHERE username=$1')
      Database.connection.prepare('user_get_hash', 'SELECT password_hash from USERS where username=$1')
      Database.connection.prepare('user_update_password', 'UPDATE users SET password_hash=$1 WHERE username=$2')
      Database.connection.prepare('user_insert', 'INSERT INTO users (username, first_name, last_name, email, telephone, password_hash)
      VALUES($1, $2, $3, $4, $5, $6);')
    end

    def _users_from_query(query)
      # the password hash is intentionally omitted
      query.map { |it| User.new(it[:username], it[:first_name], it[:last_name], it[:email], it[:telephone]) }
    end

    def get_by_username(username)
      _users_from_query(Database.connection.exec_prepared('user_by_username', [username]))[0]
    end

    def verify_password(username, password)
      result = Database.connection.exec_prepared('user_get_hash', [username])
      BCrypt::Password.new(result[:password_hash]) == password
    end

    def create_user(user, password)
      Database.connection.exec_prepared('user_insert', [user.username, user.first_name, user.last_name, user.email, user.telephone, BCrypt::Password.create(password)])
    end
  end
end