require 'date'

class Space
  attr_reader :id, :name, :owner, :description, :price_per_night, :available_start, :available_end

  def initialize(id, name, owner, description, price_per_night, available_start, available_end)
    @id = id
    @name = name
    @owner = owner
    @description = description
    @price_per_night = price_per_night
    @available_start = available_start
    @available_end = available_end
  end

  class << self
    def setup_prepared_statements
      Database.connection.prepare('space_by_id', 'SELECT * FROM spaces WHERE id=$1')
      Database.connection.prepare('space_insert', "INSERT INTO spaces (id, name, owner, description, price_per_night, available_start, available_end) VALUES($1, $2, $3, $4, $5, $6, $7);")
      Database.connection.prepare('all_spaces', 'SELECT * FROM spaces')
    end
  
    def _spaces_from_query(query)
      query.map do |it| Space.new(
        it[:id],
        it[:name], 
        it[:owner], 
        it[:description],
        it[:price_per_night], 
        Date.parse(it[:available_start]), 
        Date.parse(it[:available_end])) 
      end
    end
  
    def get_by_id(id)
      _spaces_from_query(Database.connection.exec_prepared('space_by_id', [id]))[0]
    end

    def insert_space(space)
      Database.connection.exec_prepared('space_insert', [space.id, space.name, space.owner, space.description, space.price_per_night, space.available_start, space.available_end])             
    end

    def get_spaces
      _spaces_from_query(Database.connection.exec_prepared('all_spaces'))
    end
  end
end