class Post < ApplicationRecord
  include Discard::Model
  has_one_attached :image, dependent: :destroy
  belongs_to :user
end
