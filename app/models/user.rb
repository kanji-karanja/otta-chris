class User < ApplicationRecord
  attr_accessor :remember_token

  # use before_save callback to downcase the email attribute
  # before saving the user
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # the has_secure_pwd includes a presence validation
  # but only applies to records with empty passwords
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string
  def User.digest(string)
   # Line for cost parameters and password digests from the secure
   # password source code 
   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
   BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def User.new_token
   SecureRandom.urlsafe_base64
  end

  # Remember a user in the db for use in persistent sessions
  def remember
   self.remember_token = User.new_token
   update_attribute(:remember_digest, User.digest(remember_token))
  end
 
  # Returns true if the given token matches the digest 
  def authenticated?(remember_token)
   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
