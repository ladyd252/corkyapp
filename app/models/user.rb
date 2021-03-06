# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ActiveRecord::Base
  validates :email, :password_digest, :session_token, presence: true
  validates :email, :session_token, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  attr_reader :password

  after_initialize :ensure_session_token

  has_many :events, class_name: "Event", foreign_key: :creator_id

  has_many :posts, through: :events, source: :posts

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

  def set_up_data
    self.events.each do |event|
      event.delete
    end
    e1 = self.events.find_or_create_by(title: "Welcome to Corky", phone_number: "+14157693892", event_date: Date::today )
    e1.posts.find_or_create_by(body: "Welcome, guest!", picture_url: "https://s3-us-west-1.amazonaws.com/ladyd252/happy-kitten-kittens-5890512-1600-1200.jpg")
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(@password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save
  end

end
