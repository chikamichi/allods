module CharacterHelper
  # Display a character's nickname, and if required and available,
  # its LootStatus' status for a given set of conditions.
  #
  # If no conditions are provided or if conditions lead to no record being
  # found or if applying conditions raises an error, the character's nickname
  # is returned. Otherwise, the character's loot status is appended.
  #
  # @param [Character] character
  # @param [Hash] any number of `:key => value` conditions to be applied to
  #   `character.loot_statuses`. Some special keys are interpreted and will
  #   not make it to the WHERE clause, see options.
  # @option [true, false] :to_link (false) whether to render a link
  # @return [String]
  #
  # @example
  #
  #   display_nickname_and_loot_status Character.last, :loot_machine_id => 10
  #
  def display_nickname_and_loot_status(character, *args)
    parameters = args.first
    options = {
      :link_to => false
    }
    options[:link_to] = !!parameters.delete(:link_to)

    return character.nickname if parameters.empty?

    ls = character.loot_statuses.where(args.first)

    if ls.empty?
      character.nickname
    else
      nickname = character.nickname
      nickname = link_to character.nickname, character_url(character), :class => class_for(character) if options[:link_to]
      I18n.t('characters.display_nickname_and_loot_status',
        :nickname => nickname,
        :status   => I18n.t("loot_statuses.statuses.#{ls.first.status}")).html_safe
    end
  rescue ActiveRecord::ActiveRecordError => e
    character.nickname
  end
end
