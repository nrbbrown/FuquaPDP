class Task < ActiveRecord::Base
    has_many :tasksprogresses
	belongs_to :goal
end
