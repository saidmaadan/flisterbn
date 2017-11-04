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

  validates :first_name, presence: true, length:{maximum: 20}
  # validates :last_name, presence: true,  length:{maximum: 20}
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :listings
  has_many :reservations

   def full_name
     [first_name, last_name].join(" ")
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
        user.full_name = auth.info.name
        user.username = auth.extra.raw_info.username
        user.image = auth.info.image
        user.uid = auth.uid
        user.provider = auth.provider

        # If you are using confirmable and the provider(s) you use validate emails,
        # uncomment the line below to skip the confirmation emails.
        user.skip_confirmation!
      end
    end
  end


  #  def self.from_omniauth(auth)
  #    user = User.where(email: auth.info.email).first
  #    if user
  #      return user
  #    else
  #      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #         user.email = auth.info.email
  #         user.password = Devise.friendly_token[0,20]
  #         user.full_name = auth.info.name
  #         user.image = auth.info.image
  #         user.username = auth.info.username
  #         user.uid = auth.uid
  #         user.provider = auth.provider
  #         # If you are using confirmable and the provider(s) you use validate emails,
  #         # uncomment the line below to skip the confirmation emails.
  #         user.skip_confirmation!
  #       end
  #    end
  # end
end
