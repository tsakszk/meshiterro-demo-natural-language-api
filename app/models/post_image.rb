class PostImage < ApplicationRecord
  mount_uploader :image, ImageUploader

  # --------------------------------------
  # Relations
  # --------------------------------------
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tags, dependent: :destroy

  # --------------------------------------
  # Validations
  # --------------------------------------
  validates :shop_name, presence: true
  validates :image, presence: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
