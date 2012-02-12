class Task < ActiveRecord::Base
    has_many :tasksprogress
	belongs_to :goal
end
