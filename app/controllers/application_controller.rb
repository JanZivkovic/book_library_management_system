class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  private
    def authenticate_request
      header = request.headers["Authorization"]
      if header.nil?
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
      #header = header.split(" ").last
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    end
end
