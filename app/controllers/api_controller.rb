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
        
    end
end
