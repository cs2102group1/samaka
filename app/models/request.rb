class Request < ActiveRecord::Base
  self.primary_keys = :requester, :request_datetime
  belongs_to :users, dependent: :destroy

  def self.insert(params)
    query = "INSERT INTO requests (requester, status, topup_amount, request_datetime)
             VALUES ('#{params[:requester]}', '#{params[:status]}', '#{params[:topup_amount]}',
             '#{params[:request_datetime]}');"
    ActiveRecord::Base.connection.execute(query)
  end

  def self.find(params)
    query = <<-FIND
            SELECT * FROM requests r WHERE
            r.requester = '#{params[:requester]}' AND
            r.request_datetime = '#{params[:request_datetime]}';
            FIND
    self.find_by_sql(query)
  end

  def self.approve(params)
    amount = params[:topup_amount].to_f
    query1 = "UPDATE users SET credit = credit + #{amount}
            WHERE email = '#{params[:requester]}';"
    ActiveRecord::Base.connection.execute(query1)

    query2 = "UPDATE requests SET status = false
              WHERE requester = '#{params[:requester]}' AND request_datetime = '#{params[:request_datetime]}';"
    ActiveRecord::Base.connection.execute(query2)
  end
end
