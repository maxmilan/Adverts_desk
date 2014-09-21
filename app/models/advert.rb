class Advert < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
  validates :price, presence: true, numericality: {greater_than: 0 }

  has_many :images, dependent: :destroy
  belongs_to :category
  belongs_to :user

  accepts_nested_attributes_for :images, :allow_destroy => true

end
