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