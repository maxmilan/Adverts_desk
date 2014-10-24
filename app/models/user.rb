# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  surname                :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  role_id                :integer
#

class User < ActiveRecord::Base
  belongs_to :role
  has_many :adverts, dependent: :destroy

  before_create :create_role

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, uniqueness: true, presence: true
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    unless user
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email
      unless user
				case auth.provider
        when 'facebook'
          @name = auth.extra.raw_info.first_name
          @surname = auth.extra.raw_info.last_name
        when 'twitter'
          @full_name = auth.extra.raw_info.name
          @name, @surname = @full_name.split(' ')
        when 'vkontakte'
          @name = auth.extra.raw_info.first_name
          @surname = auth.extra.raw_info.last_name
        when 'google_oauth2'
          @name = auth.extra.raw_info.given_name
          @surname = auth.extra.raw_info.family_name
        end
        user = User.new(
            name: @name,
            surname: @surname,
            email: email || "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0, 20]
        )
        user.save!
      end
    end
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end

  def admin?
    role && role.name == 'admin'
  end

  def user?
    role && role.name == 'user'
  end

private

  def create_role
    self.role = Role.find_by_name(:user)
  end
end
