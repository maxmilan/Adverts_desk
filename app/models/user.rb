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
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, uniqueness: true, presence: true
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        if auth.provider.eql? "facebook"
          user = User.new(
              name: auth.extra.raw_info.first_name,
              surname: auth.extra.raw_info.last_name,
              #username: auth.info.nickname || auth.uid,
              email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
              password: Devise.friendly_token[0,20]
          )
        elsif auth.provider.eql? "twitter"
          @name = auth.extra.raw_info.name
          user = User.new(
              name: @name[0,@name.index(' ')],
              surname: @name[@name.index(' ') + 1, @name.length - 1],
              #username: auth.info.nickname || auth.uid,
              email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
              password: Devise.friendly_token[0,20]
          )
        elsif auth.provider.eql? "vkontakte"
          user = User.new(
              name: auth.extra.raw_info.first_name,
              surname: auth.extra.raw_info.last_name,
              #username: auth.info.nickname || auth.uid,
              email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
              password: Devise.friendly_token[0,20]
          )
        elsif auth.provider.eql? "google_oauth2"
          user = User.new(
              name: auth.extra.raw_info.given_name,
              surname: auth.extra.raw_info.family_name,
              #username: auth.info.nickname || auth.uid,
              email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
              password: Devise.friendly_token[0,20]
          )
        end
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def admin?
    !self.role.nil? && self.role.name.eql?('admin')
  end

  def user?
    !self.role.nil? && self.role.name.eql?('user')
  end

private
  def create_role
    self.role = Role.find_by_name(:user)
  end

end
