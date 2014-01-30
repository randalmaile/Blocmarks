class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :name
  has_many :bookmarks
  has_many :hashtags
  has_many :favorites, dependent: :destroy

  attr_accessor :password
  before_save :encrypt_password
  before_create :set_member

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

def self.authenticate(email, password)
  user = find_by_email(email)
  if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    user
  else
    nil
  end
end

def encrypt_password
  if password.present?
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end
end

def favorited(bookmark)
  self.favorites.where(bookmark_id: bookmark.id).first
end

ROLES = %w[member moderator admin]
def role?(base_role)
  role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
end 

private

def set_member
  self.role = "member"
end


end
