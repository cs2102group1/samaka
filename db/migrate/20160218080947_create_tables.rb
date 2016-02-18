class CreateTables < ActiveRecord::Migration
  def change
    create_table :users, {id: false} do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.integer :role, null: false
      t.string :phone_number, null: false
      t.text :carplates, array: true, default: []
    end

    execute "ALTER TABLE users ADD PRIMARY KEY (email);"

    create_table :journeys, {id: false} do |t|
      t.string :pickup_point, null: false
      t.string :dropoff_point, null: false
      t.float :price, null: false
      t.integer :available_seats, null: false
      t.string :carplate
      t.datetime :start
    end

    execute "ALTER TABLE journeys ADD PRIMARY KEY (start, carplate);"

    create_table :drivers, {id: false} do |t|
      t.string :email, null: false 
      t.datetime :start, null: false
      t.string :carplate, null: false
      t.integer :passenger_rating
      t.text :passenger_review
    end

    execute "ALTER TABLE drivers ADD PRIMARY KEY (email, start, carplate);"
    execute "ALTER TABLE drivers ADD FOREIGN KEY (email) REFERENCES users(email)
            ON DELETE CASCADE;"
    execute "ALTER TABLE drivers ADD FOREIGN KEY (start, carplate) REFERENCES journeys(start, carplate)
            ON DELETE CASCADE;"

    create_table :passengers, {id: false} do |t|
      t.string :email, null: false
      t.datetime :start, null: false
      t.string :carplate, null: false
      t.integer :driver_rating
      t.text :driver_review
      t.boolean :onboard, null: false, default: true
    end

    execute "ALTER TABLE passengers ADD PRIMARY KEY (email, start, carplate);"
    execute "ALTER TABLE passengers ADD FOREIGN KEY (email) REFERENCES users(email)
            ON DELETE CASCADE;"
    execute "ALTER TABLE passengers ADD FOREIGN KEY (start, carplate) REFERENCES journeys(start, carplate)
            ON DELETE CASCADE;"
  end
end
