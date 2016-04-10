class CreateRequest < ActiveRecord::Migration
  def change
    create_query = <<-SQL
    CREATE TABLE requests(
      requester VARCHAR REFERENCES users(email),
      status BOOLEAN NOT NULL DEFAULT true,
      topup_amount INTEGER,
      request_datetime TIMESTAMP WITHOUT TIME ZONE,
      PRIMARY KEY(request_datetime, requester)
    );
    SQL

    execute(create_query)
  end
end
