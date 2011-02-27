require 'acceptance/acceptance_helper'

feature "LootMachines, aka. Groups", %q{
  In order to follow the evolution of a group of players
  As a player myself
  I want to be able to display a group
} do

  background do
    # FIXME: in fact, the factories defined with blueprint cannot handle
    # custom attributes, so implement that using the default syntax
    lm = Factory.create :loot_machine, :title => 'Raid'
    ch = Factory.create :character, :nickname => 'Joe'
    ls = Factory.create :loot_status, {
      :loot_machine_id => lm.id,
      :character_id => ch.id
    }
  end

  scenario "Groups index" do
    visit '/loot_machines'
    page.should have_content('Raid')
    page.should have_content('Joe')
  end

end


