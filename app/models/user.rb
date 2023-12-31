# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many  :books, class_name: "Book", foreign_key: "user_id", dependent: :destroy
  has_many  :following, class_name: "Follow", foreign_key: "user_id", dependent: :destroy
  has_many  :comments, class_name: "Comment", foreign_key: "user_id", dependent: :destroy

  def self.ransackable_attributes(auth_object = nil )
    ["user_id", "commentable_id"]
  end 
end
