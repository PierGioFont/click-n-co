class Shop < ApplicationRecord
  # attr_accessor :distance
  belongs_to :user
  belongs_to :category
  has_many :opening_hours
  has_many :products
  has_many :orders

  validates :name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
  geocoded_by :address

  after_validation :geocode, if: :address_changed?
  has_many :product_categories, through: :products
  has_attachment :photo

end

