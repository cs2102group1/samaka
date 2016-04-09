namespace :db do
  require 'populator'
  require 'faker'

  gen = Random.new

  desc 'Erase the database and populate it'
  task :populate => ['db:erase', 'db:populate_journeys']

  desc 'Populate only'
  task :populate_only => ['db:populate_journeys']

  desc 'Clear database'
  task :erase => :environment do
    delete_all_query = <<-DELETE_ALL
                        DELETE FROM drivers;
                        DELETE FROM passengers;
                        DELETE FROM journeys;
                        DELETE FROM cars;
                        DELETE FROM users;
                        DELETE_ALL
    ActiveRecord::Base.connection.execute(delete_all_query)
  end

  desc 'Create fake journeys'
  task :populate_journeys => :environment do
    user_emails = []
    cars = []

    300.times do |n|
      User.populate 1 do |u|
        u.email = Faker::Internet.email
        user_emails << u.email
        u.username = Faker::Internet.user_name + n.to_s
        u.role = 'member'
        u.phone_number = Faker::PhoneNumber.phone_number
        u.encrypted_password = Faker::Internet.password
        u.sign_in_count = 1
        u.credit = Faker::Commerce.price
        if gen.rand() > 0.5
          Car.populate 1 do |c|
            c.car_plate = Faker::Number.hexadecimal(6)
            c.owner = u.email
            cars << c
          end
        end
      end
    end

    Journey.populate 300 do |j|
      car = cars[gen.rand(0..cars.length-1)]
      j.pickup_point = Faker::Address.street_address
      j.dropoff_point = Faker::Address.street_address
      j.price = Faker::Commerce.price
      j.available_seats = gen.rand(1..4)
      j.car_plate = car.car_plate
      j.start_time = 3.days.ago..Time.now

      Passenger.populate 1 do |pa|
        pa.email = user_emails[gen.rand(0..299)]
        pa.start_time = j.start_time
        pa.car_plate = j.car_plate
        pa.onboard = true
      end

      Driver.populate 1 do |d|
        d.email = car.owner
        d.start_time = j.start_time
        d.car_plate = j.car_plate
      end
    end

  end
end
