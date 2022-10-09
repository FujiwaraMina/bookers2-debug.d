class Book < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_image
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  has_many :book_tags,dependent: :destroy
  has_many :tags,through: :book_tags
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search,word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete.Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(name: new)
      self.tags << new_book_tag
    end
  end
end