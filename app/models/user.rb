class User < ActiveRecord::Base
  has_one :merchant
  has_secure_password

  validates_presence_of [:password_confirmation, :password, :email], :on => :create
end
