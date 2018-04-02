class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, default_url: 'avatar.png'

  validates_attachment :avatar, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { in: 0..300.kilobytes }

end
