class User < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :follows, foreign_key: :follower_id
	validates :password, presence: {message: "is required"}
	def following?(other_user)
		followers = follows.collect {|f| f.followee_id}
		followers.include?(other_user.id)
	end
end

class Post < ActiveRecord::Base
	belongs_to :user
end

class Follow < ActiveRecord::Base
	belongs_to :user, foreign_key: :followee_id
end

