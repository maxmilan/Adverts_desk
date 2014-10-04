# == Schema Information
#
# Table name: adverts
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  body          :text
#  price         :decimal(, )
#  created_at    :datetime
#  updated_at    :datetime
#  state         :string(255)
#  advert_type   :string(255)
#  category_id   :integer
#  user_id       :integer
#  reject_reason :text
#

class Advert < ActiveRecord::Base
  include AASM

  include Tire::Model::Search
  include Tire::Model::Callbacks

  validates :title, presence: true
  validates :body, presence: true
  validates :price, presence: true, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, numericality: {greater_than: 0 }
  validates :category_id, presence: true
  validate :type_must_be_correct
  validate :must_have_reject_reason

  has_many :images, dependent: :destroy
  belongs_to :category
  belongs_to :user

  accepts_nested_attributes_for :images, :allow_destroy => true

  aasm :column => "state" do
    state :new
    state :waiting
    state :rejected
    state :published
    state :archive

    event :reject do
      transitions :from => :waiting, :to => :rejected
    end

    event :accept do
      transitions :from => :waiting, :to => :published
    end

    event :wait do
      transitions :from => [:new, :archive], :to => :waiting
    end

    event :send_to_archive do
      transitions :from => [:new, :waiting, :rejected, :published], :to => :archive
    end

    event :refresh do
      transitions :from => [:new, :waiting, :published, :rejected, :archive], :to => :new
    end

  end

  def self.archivate_old_adverts
    Advert.all.each do |advert|
      if advert.published? && (advert.updated_at < Time.now.days_ago(1))
        advert.send_to_archive
        advert.save
      end
    end
  end

  def self.full_search params
    @result = tire.search(load: true) do
      query { string params[:query]} unless params[:query].empty?
    end
    @result.select{|advert| advert.published?}
  end

  def type_must_be_correct
    unless ['sell', 'buy', 'exchange', 'service', 'loan'].include? advert_type
      errors.add(:type_error, "invalide advert type")
    end
  end

  def must_have_reject_reason
    if self.rejected? && (self.reject_reason.nil? || self.reject_reason.empty?)
      errors.add(:reject_reason_error, "reject reason can't be nil" )
    end
  end

end
