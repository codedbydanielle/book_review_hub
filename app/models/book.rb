class Book < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_one_attached :cover_image

  attr_accessor :open_library_cover_url

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, uniqueness: true, allow_blank: true
end
