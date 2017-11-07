class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  # validates :password, length: { minimum: 6, allow_blank: true }

  # validates :email, presence: true,
  #                 format: /\A\S+@\S+\z/,
  #                 uniqueness: { case_sensitive: false }

  extend FriendlyId
  friendly_id :slug_users, use: :slugged

   def slug_users
     [
       :username,
       [:username, :user_name]
     ]
   end


  validates :first_name, presence: true, length:{maximum: 20}
  validates :last_name, presence: true,  length:{maximum: 20}
  #validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :listings
  has_many :reservations
  has_many :guest_reviews, class_name: "GuestReview", foreign_key: "guest_id"
  has_many :host_reviews, class_name: "HostReview", foreign_key: "host_id"

   def full_name
     [first_name, last_name].join(" ")
   end

   def user_name
       [first_name, last_name, @user_id].join('')
   end

   def fullname
     [first_name, last_name].join("")
   end

   def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first

    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.username = auth.info.username
        # user.username = auth.extra.raw_info.username
        user.image = auth.info.image
        user.uid = auth.uid
        user.provider = auth.provider

        # If you are using confirmable and the provider(s) you use validate emails,
        # uncomment the line below to skip the confirmation emails.
        user.skip_confirmation!
      end
    end
  end
end
  # user.last_name = auth.info.name
