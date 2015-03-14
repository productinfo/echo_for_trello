class User < ActiveRecord::Base
  has_many :cards
  has_many :card_logs

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first || create_from_omniauth(auth)
    user.update_attributes(oauth_token: auth["credentials"]["token"]) unless user.oauth_token == auth["credentials"]["token"]
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.full_name = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
      user.oauth_token = auth["credentials"]["token"]
    end
  end

  def admin?
    # TODO: Add real roles (or at least a flag) instead of just checking my ID.
    id == 1
  end
end
