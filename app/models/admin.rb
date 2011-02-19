# An admin has special rights to create, update and destroy resources. He may
# have users' characters join or leave group.
#
class Admin < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :timeoutable, :validatable,
         :timeout_in => 20.minutes
end
