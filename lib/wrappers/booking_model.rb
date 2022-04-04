class BookingModel

	attr_reader :id, :space, :booking_user, :date, :status

	def initialize(id, space, booking_user, date, status)
		@id = id
		@space = space
    @booking_user = booking_user
    @date = date
    @status = status
  end

	class << self

  	def setup_prepared_statements
   	 Database.connection.prepare('booking_by_id', 'SELECT * FROM bookings WHERE id=$1')
		end

   	def _booking_from_query(query)
   	 query.map do { |it| BookingModel.new(
				it[:space], 
				it[:booking_user], 
				Date.parse it[:date], 
			 	it[:status]) }
			end
  	end

  	def get_by_id(id)
   	 _booking_from_query(Database.connection.exec_prepared('booking_by_id', [id]))[0]
  	end
	end
end
