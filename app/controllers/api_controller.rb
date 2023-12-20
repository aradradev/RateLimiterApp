class ApiController < ApplicationController
    before_action :rate_limite, only: [:limited]

end
