class Goal < ActiveRecord::Base
    has_many :tasks, :dependent => :destroy, :order => "startdue ASC, due ASC"
    accepts_nested_attributes_for :tasks, :allow_destroy => true,
	
end


#:reject_if => lambda { |a| a[:task].blank? }