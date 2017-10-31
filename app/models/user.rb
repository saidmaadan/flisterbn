class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :password, length: { minimum: 6, allow_blank: true }

  validates :email, presence: true,
                  format: /\A\S+@\S+\z/,
                  uniqueness: { case_sensitive: false }

  validates :first_name, presence: true, length:{maximum: 20}
  validates :last_name, presence: true,  length:{maximum: 20}
  validates :username, presence: true,
                     format: /\A[A-Z0-9]+\z/i,
                     uniqueness: { case_sensitive: false }

   def full_name
     [first_name, last_name].join(" ")
   end
end
