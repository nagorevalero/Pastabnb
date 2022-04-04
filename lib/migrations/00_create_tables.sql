CREATE TABLE IF NOT EXISTS users(
    username TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    telephone TEXT NULL
);

CREATE TABLE IF NOT EXISTS spaces(
    id SERIAL PRIMARY KEY,
    owner TEXT NOT NULL REFERENCES users (username) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    price_per_night FLOAT NOT NULL,
    available_start DATE NOT NULL,
    available_end DATE NOT NULL
);

CREATE TYPE booking_status AS ENUM ('pending', 'approved', 'rejected');

CREATE TABLE IF NOT EXISTS bookings(
    space INT NOT NULL REFERENCES spaces (id) ON DELETE CASCADE,
    bookingUser TEXT NOT NULL REFERENCES users (username) ON DELETE CASCADE,
    date DATE NOT NULL,
    status booking_status NOT NULL
)