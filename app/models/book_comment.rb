class BookComment < ApplicationRecord
  belongs_to :user
  belongs_to :book

  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
