class Order < ApplicationRecord
  has_many :ordered_products
  belongs_to :user
  has_many :products, through: :ordered_products
end
