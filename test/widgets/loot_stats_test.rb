require 'test_helper'

class LootStatsTest < Apotomo::TestCase
  has_widgets do |root|
    root << widget(:loot_stats, 'me')
  end
  
  test "display" do
    render_widget 'me'
    assert_select "h1"
  end
end
