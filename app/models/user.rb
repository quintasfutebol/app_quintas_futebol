class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_and_belongs_to_many :accounts

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
