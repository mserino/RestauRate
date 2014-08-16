class Restaurant < ActiveRecord::Base
	has_many :reviews
	belongs_to :user
	validates :name, presence: true, format: {with: /\A[A-Z]/}
	validates :cuisine, presence: true, length: {minimum: 3}

	def average_rating
		return 'N/A' if reviews.none?
		reviews.average(:rating)
	end
end

