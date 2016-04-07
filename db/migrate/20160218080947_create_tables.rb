class CreateTables < ActiveRecord::Migration
  def change
    create_query = <<-SQL
    CREATE TABLE users(
      email VARCHAR,
      username VARCHAR,
      role VARCHAR NOT NULL,
      phone_number VARCHAR NOT NULL,
      credit REAL,
      PRIMARY KEY (email),
      UNIQUE (username)
    );
    CREATE TABLE cars(
      car_plate VARCHAR PRIMARY KEY,
      owner VARCHAR NOT NULL,
      FOREIGN KEY(owner) REFERENCES users(email)
    );
    CREATE TABLE journeys(
      pickup_point VARCHAR NOT NULL,
      dropoff_point VARCHAR NOT NULL,
      price REAL NOT NULL,
      available_seats INTEGER NOT NULL,
      car_plate VARCHAR NOT NULL,
      start_time TIMESTAMP WITHOUT TIME ZONE,
      PRIMARY KEY (start_time, car_plate)
    );
    CREATE TABLE drivers(
      email VARCHAR REFERENCES users(email),
      start_time TIMESTAMP WITHOUT TIME ZONE,
      car_plate VARCHAR,
      passenger_rating INTEGER,
      passenger_review TEXT,
      PRIMARY KEY (email, start_time, car_plate),
      FOREIGN KEY (start_time, car_plate) REFERENCES journeys(start_time, car_plate)
    );
    CREATE TABLE passengers(
      email VARCHAR REFERENCES users(email),
      start_time TIMESTAMP WITHOUT TIME ZONE,
      car_plate VARCHAR,
      driver_rating INTEGER,
      driver_review TEXT,
      onboard BOOLEAN NOT NULL DEFAULT true,
      PRIMARY KEY (email, start_time, car_plate),
      FOREIGN KEY (start_time, car_plate) REFERENCES journeys(start_time, car_plate)
    );
    SQL

    execute(create_query)
  end
end
