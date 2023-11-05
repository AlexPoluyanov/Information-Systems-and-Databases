CREATE TYPE num_type AS ENUM (
  'individual',
  'legal entity',
  'forigner citizen',
  'army'
);

CREATE TYPE car_body_type AS ENUM (
  'sedan',
  'limousine',
  'hatchback',
  'liftback',
  'universal',
  'coupe',
  'convertible',
  'cabriolet',
  'roadster',
  'targa',
  'minivan',
  'pickup',
  'truck',
  'crossover',
  'other'
);

CREATE TYPE transmission_type AS ENUM ('variator', 'mechanical', 'automatic', 'robotic');

CREATE TYPE wheel_drive_type AS ENUM ('front-wheel', 'rear-wheel', 'all-wheel');

CREATE TYPE rudder AS ENUM ('left', 'right');

CREATE TABLE
  IF NOT EXISTS "users" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(128) NOT NULL,
    "surname" VARCHAR(128) NOT NULL,
    "username" VARCHAR(256) UNIQUE NOT NULL,
    "phone" VARCHAR(16) NOT NULL,
    "hash" VARCHAR(256) NOT NULL,
    "salt" VARCHAR(256) NOT NULL
  );

CREATE TABLE
  IF NOT EXISTS "cars" (
    "car_num" VARCHAR(16) PRIMARY KEY,
    "num_type" num_type,
    "year_of_issue" SMALLINT,
    "color" VARCHAR(32),
    "car_body_type" car_body_type,
    "transmission" transmission_type,
    "wheel_drive_type" wheel_drive_type,
    "rudder" rudder,
    CHECK (year_of_issue > 1884)
  );

CREATE TABLE
  IF NOT EXISTS "photos" (
    "id" SERIAL PRIMARY KEY,
    "car_num" VARCHAR(16) REFERENCES cars (car_num),
    "link" VARCHAR(256) NOT NULL,
    "date" date NOT NULL,
    "added_by" int REFERENCES users (id)
  );

CREATE TABLE
  IF NOT EXISTS "insurance" (
    "id" SERIAL PRIMARY KEY,
    "car_num" VARCHAR(16) REFERENCES cars (car_num),
    "company" VARCHAR(256) NOT NULL,
    "type" VARCHAR(128) NOT NULL,
    "amount" NUMERIC(15, 2),
    "price" NUMERIC(15, 2),
    "start_date" date NOT NULL,
    "end_date" date NOT NULL
  );

CREATE TABLE
  IF NOT EXISTS "crashes" (
    "id" SERIAL PRIMARY KEY,
    "car_num" VARCHAR(16) REFERENCES cars (car_num),
    "date" date NOT NULL,
    "description" text
  );