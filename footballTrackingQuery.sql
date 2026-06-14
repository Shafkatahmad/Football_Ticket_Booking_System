CREATE EXTENSION IF NOT EXISTS citext;
CREATE TYPE role AS ENUM('Ticket Manager', 'Football Fan');
CREATE TYPE match_status AS ENUM('Available','Selling Fast', 'Sold Out', 'Postponed');
CREATE TYPE payment_status AS ENUM('Pending', 'Confirmed', 'Cancelled', 'Refunded');

-- CREATING users TABLE
CREATE TABLE users(
  user_id SERIAL PRIMARY KEY,
  full_name VARCHAR(50) NOT NULL,
  email CITEXT UNIQUE NOT NULL,
  role role NOT NULL DEFAULT 'Football Fan',
  phone_number VARCHAR(20)
);

INSERT INTO users (full_name, email, role, phone_number)
VALUES
  ('Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
  ('Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
  ('Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
  ('Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);


-- CREATED matches TABLE
CREATE TABLE matches(
  match_id SERIAL PRIMARY KEY,
  fixture VARCHAR(100) NOT NULL,
  tournament_category VARCHAR(100) NOT NULL DEFAULT 'Premier League',
  base_ticket_price NUMERIC(10,2) NOT NULL CHECK (base_ticket_price >= 0),
  match_status match_status NOT NULL DEFAULT 'Available'
);

INSERT INTO matches (fixture, tournament_category, base_ticket_price, match_status)
VALUES
  ('Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
  ('Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
  ('Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
  ('AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
  ('Juventus vs Roma', 'Serie A', 80.00, 'Available');


  -- CREATED bookings TABLE
  CREATE TABLE bookings(
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id) NOT NULL,
  match_id INT REFERENCES matches(match_id) NOT NULL,
  seat_number VARCHAR(10) NOT NULL,
  payment_status payment_status DEFAULT 'Pending',
  total_cost NUMERIC(10,2) CHECK(total_cost >= 0)
);

INSERT INTO bookings (user_id, match_id, seat_number, payment_status, total_cost)
VALUES
  (1, 1, 'A-12', 'Confirmed', 150.00),
  (1, 2, 'B-04', 'Confirmed', 120.00),
  (2, 1, 'A-13', 'Confirmed', 150.00),
  (3, 2, 'C-20', 'Pending', 120.00);



-- QUERIES:

-- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.
SELECT match_id, fixture, base_ticket_price
FROM matches
WHERE tournament_category = 'Champions League' AND match_status = 'Available';

-- Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).
SELECT user_id, full_name, email
FROM users
WHERE full_name ILIKE 'tanvir%'
  OR full_name ILIKE '%haque%';

-- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.
SELECT user_id, match_id, COALESCE(payment_status, 'Action Required') AS payment_status
FROM bookings
WHERE payment_status IS NULL;

-- Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.
SELECT b.booking_id, u.full_name, m.fixture, b.total_cost
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN matches m ON b.match_id = m.match_id;

-- Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.
SELECT u.user_id, u.full_name, b.booking_id
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id;