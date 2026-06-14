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