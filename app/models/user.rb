# A user is a player, who may create characters.
#
class User < ActiveRecord::Base
  devise :database_authenticatable, :lockable, :recoverable,
         :rememberable, :registerable, :trackable, :timeoutable,
         :validatable, :token_authenticatable,
         :timeout_in => 2.hours

  has_many :characters

  attr_accessible :email, :password, :password_confirmation

  # Really simple state machine so that I, Master of Puppets, can
  # grant special rights to the favored.
  #
  state_machine :access_level, :initial => :member do
    event :adminship do
      transition any => :admin
    end

    event :membership do
      transition any => :member
    end

    around_transition do |user, transition, block|
      if transition.from == transition.to
        user.log_event :invalid_access_level_change, :level => transition.event
      else
        block.call
        user.log_event :access_level_change, :level => transition.event
      end
    end
  end

  state_machine :status, :initial => :inactive do
    event :activate do
      transition any => :active
    end

    event :deactivate do
      transition any => :inactive
    end
  end

  private

  def log_message(event, metadata = nil, object = nil)
    case event

    when :access_level_change
      "#{email} (##{id}) has been granted #{metadata[:level]}"

    when :invalid_access_level_change
      "#{email} (##{id}) has already been granted #{metadata[:level]}, event ignored"

    else
      return nil
    end
  end
end
