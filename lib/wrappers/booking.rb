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
      Database.connection.prepare('create_booking', "INSERT INTO bookings (space, booking_user, date, status) VALUES ($1, $2, $3, 'pending');")
      Database.connection.prepare('owner_response', "UPDATE bookings SET status = $1 WHERE id = $2");
    end

    def _bookings_from_query(query)
      query.map do |it|
        Booking.new(
          it['id'],
          it['space'],
          it['booking_user'],
          Date.parse(it['date']),
          it['status'])
      end
    end

    def get_by_id(id)
      binding.irb
      _bookings_from_query(Database.connection.exec_prepared('booking_by_id', [id]))[0]
    end

    def create_booking(booking)
      Database.connection.exec_prepared('create_booking', [booking.space, booking.booking_user, booking.date])
    end
  
    def set_response_from_owner(id, status)
      Database.connection.exec_prepared('owner_response', [status, id])
    end
  end
end