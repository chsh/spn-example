class User < ActiveRecord::Base
  # User model should have 'spn_token' field as string.

  has_many :spns

end
