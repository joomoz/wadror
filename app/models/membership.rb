class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club
  scope :confirmed, -> { where confirmed:true }
	scope :pending, -> { where confirmed:[nil,false] }

  validates_uniqueness_of :user_id, scope: :beer_club, message: "User is already a member of this club."

end
