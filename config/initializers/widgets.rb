# Each widget must subclass AllodsWidget, which defines shared methods
# and mixins useful modules, helpers…
#
class AllodsWidget < Apotomo::Widget
end

# FIXME: this is mandatory for Apotomo to find the classes
# Investigate on this matter asap. Maybe it's due to me, subclassing
# Apotomo::Widget? Try with a simpler setup.
# May add this recursively in the (auto)load_paths?
Dir["#{Rails.root}/app/widgets/**/*.rb"].each { |f| load(f) }
