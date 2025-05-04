class Account < ApplicationRecord
  has_many :account_users
  has_many :users, through: :account_users

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { name.present? && slug.blank? }

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
