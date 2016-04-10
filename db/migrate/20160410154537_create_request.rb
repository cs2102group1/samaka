class CreateRequest < ActiveRecord::Migration
  def change
    create_query = <<-SQL
    CREATE TABLE requests(
      requester VARCHAR REFERENCES users(email),
      status BOOLEAN NOT NULL DEFAULT true,
      topup_amount INTEGER,
      request_datetime TIMESTAMP WITHOUT TIME ZONE,
      PRIMARY KEY(requester, request_datetime)
    );
    SQL

    execute(create_query)
  end
end
