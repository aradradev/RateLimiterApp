class ApiController < ApplicationController
    before_action :rate_limit, only: [:limited]

    def limited
        render json: {message: 'This is a limited endpoint'}
    end

    def unlimited
        render json: {message: 'This is an unlimited endpoint'}
    end

    private

    def rate_limit
        key = "user#{request.remote_ip}"
        bucket_capacity = 0
        refill_rate = 1

        current_tokens = $redis.get(key).to_i
        last_request_time = $redis.get("#{key}:last_request_time")
        elapsed_time = Time.now.to_i - last_request_time

        refill_amount = [time_elapsed * refill_rate, bucket_capacity].min
        new_tokens = [current_tokens + refill_amount, bucket_capacity].min

        $redis.set("#{key}last_request_time", Time.now.to_i)

        if new_tokens >= 1
            $redis.set(key, new_tokens - 1)
        else
            render json: {message: 'Rate limit exceeded'}, status: :too_many_requests
        end
    end
end
