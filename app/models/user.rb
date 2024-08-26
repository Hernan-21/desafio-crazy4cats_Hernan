# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments
  has_many :reactions
end

# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :reactions

  validates :title, presence: true
  validates :content, presence: true
end

# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  validates :content, presence: true
end

# app/models/reaction.rb
class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum reaction_type: { like: 0, dislike: 1 }

  validates :user_id, uniqueness: { scope: :post_id }
end
