class User < ActiveRecord::Base
	has_many :posts
	has_many :genres

end



class Post < ActiveRecord::Base
	belongs_to :user
	belongs_to :genres

end

class Genre < ActiveRecord::Base
	has_many :user
	has_many :posts

end