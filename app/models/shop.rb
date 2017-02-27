class Shop < ApplicationRecord
  belongs_to :user
  has_many :opening_hours
  has_many :products
  validates :name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
  validates :category, presence: true
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
