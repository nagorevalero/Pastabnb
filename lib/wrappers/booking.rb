class Booking

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

   	def _bookings_from_query(query)
   	 query.map do |it| Booking.new(
				it[:id],
				it[:space], 
				it[:booking_user], 
				Date.parse it[:date], 
			 	it[:status])
			end
  	end

  	def get_by_id(id)
   		 _bookings_from_query(Database.connection.exec_prepared('booking_by_id', [id]))[0]
  	end
	
	def create_booking(booking)
    	Database.connection.exec("INSERT INTO bookings (id, spces, booking_user, date , status) 
		VALUES('#{id}', '#{spaces}', '#{booking_user}', '#{date}', '#{status}');")
	end
end