class PlayerMatch < ApplicationRecord
  belongs_to :match
  belongs_to :player
  belongs_to :account
end
