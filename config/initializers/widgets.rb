# Each widget must subclass AllodsWidget, which defines shared methods
# and mixins useful modules, helpers…
#
class AllodsWidget < Apotomo::Widget
  helper ApplicationHelper

  attr_reader :_action_name

  before_filter :setup!

  private

  def setup!
    @state = _action_name
    @user  = options[:user]
  end
end

# FIXME: this is mandatory for Apotomo to find the classes
# Investigate on this matter asap. Maybe it's due to me, subclassing
# Apotomo::Widget? Try with a simpler setup.
# May add this recursively in the (auto)load_paths?
Dir["#{Rails.root}/app/widgets/**/*.rb"].each { |f| load(f) }
