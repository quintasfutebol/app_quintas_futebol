class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  has_many :account_users
  has_many :accounts, through: :account_users

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  accepts_nested_attributes_for :accounts
end
