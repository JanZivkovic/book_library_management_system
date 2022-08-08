backend_authentication > app > controllers > concerns > json_web_token.rb
# frozen_string_literal: true

require "jwt"
module JsonWebToken
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secret_key_base
  JWT_EXPIRES_IN = Rails.application.jwt_expires_in_days

  def jwt_encode(payload, exp = JWT_EXPIRES_IN.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[]
    HashWithIndifferentAccess.new decoded
  end
end

