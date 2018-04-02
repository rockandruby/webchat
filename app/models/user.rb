class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar,
                    storage: :s3,
                    s3_credentials: Proc.new{|a| a.instance.s3_credentials },
                    default_url: 'avatar.png'

  validates_attachment :avatar, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { in: 0..300.kilobytes }


  def s3_credentials
    {
        bucket: ENV['S3_BUCKET_NAME'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        s3_region: ENV['AWS_REGION'],
        s3_host_name: 's3.us-east-2.amazonaws.com'
    }
  end

end
