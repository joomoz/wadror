class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  validates :name, presence: true
  validates :city, presence: true
  validates :founded, numericality: { only_integer: true }

  def to_s
    "#{name}"
  end

end
