# app/controllers/api_controller.rb
class ApiController < ApplicationController
  before_action :rate_limit, only: [:limited]

  def limited
    render json: { message: 'This is a limited endpoint' }
  end

  def unlimited
    render json: { message: 'This is an unlimited endpoint' }
  end

  private

  def rate_limit
    key = "user:#{request.remote_ip}"
    bucket_capacity = 10
    refill_rate = 1

    @rate_limit_store ||= {}

    current_tokens = (@rate_limit_store[key] ||= 0)
    last_request_time = (@rate_limit_store["#{key}:last_request_time"] ||= Time.now.to_i)
    time_elapsed = Time.now.to_i - last_request_time

    refill_amount = [time_elapsed * refill_rate, bucket_capacity].min
    new_tokens = [current_tokens + refill_amount, bucket_capacity].min

    @rate_limit_store["#{key}:last_request_time"] = Time.now.to_i

    if new_tokens >= 1
      @rate_limit_store[key] = new_tokens - 1
    else
      # Directly modify the response
      response.headers['Retry-After'] = '10' # You can adjust this value as needed
      render json: { error: 'Rate limit exceeded' }, status: :too_many_requests
      response.status = :too_many_requests
    end
  end
end
