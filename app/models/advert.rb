class Advert < ActiveRecord::Base
  include AASM

  validates :title, presence: true
  validates :body, presence: true
  validates :price, presence: true, numericality: {greater_than: 0 }

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

    event :wait do
      transitions :from => [:new, :archive], :to => :waiting
    end

    event :publicate do
      transitions :from => :waiting, :to => :published
    end

    event :archivate do
      transitions :from => [:new, :waiting, :rejected, :published], :to => :archive
    end

    event :refresh do
      transitions :from => [:new, :waiting, :published, :rejected, :archive], :to => :new
    end

  end


end
