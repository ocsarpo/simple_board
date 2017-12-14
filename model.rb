DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/board.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :writer, String, :default => "익명"
  property :title, String
  property :content, Text
  property :created_at, DateTime
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :email, String
  property :password, Text
  property :is_admin, Boolean, :default => false
  property :name, String, :default => ""
  property :story, String, :default => ""
  property :created_at, DateTime
end

DataMapper.finalize

Post.auto_upgrade!
User.auto_upgrade!
