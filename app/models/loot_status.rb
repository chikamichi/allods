class LootStatus < ActiveRecord::Base
  belongs_to :character
  belongs_to :loot_machine

  has_paper_trail :only => :bump, :meta => { :bump => Proc.new { |loot_status| loot_status.bump } }

  # Loot actions. Given its current score and the score of the other
  # member of a group, the character has a loot status enforced by the
  # group looting strategy/scheme.
  STATUS = [:need, :greed]

  #scope :archetype, lambda { |archetype|
    #includes(:character).where('characters.archetype=?', archetype)
  #}

  # Compute a dependent meta.
  #
  # @param [Symbol] what :score, :status
  # @param [Hash] options
  # @option options [true, false] :force (false) whether to force the computation
  #
  def compute(what, options = {})
    self.send :"compute_#{what}", options
  end

  # Number of wins, that is, sum of needs and greeds.
  # This value is not stored as a metada, as it is just
  # an addition.
  #
  # @return [Integer]
  #
  def wins
    need + greed
  end

  private

  # Personnal score computation rule:
  #
  # * score = 0 if no wins
  # * score = [-(2*need + greed) + loyalty] / (wins + 1)
  #
  # @param [Hash] options
  # @return the computed value 
  #
  def compute_score(options)
    merge_computation_options! options

    score = apply_rules_for :score
    update_attribute(:score, score)

    return self.class.type_cast!(score, :as => :score)
  end

  # Status computation rule:
  #
  # if the score is greater or equal to the max of the scores of all related
  # LootStatus records, then the status is 'need'; otherwise, it is 'greed'.
  #
  # @param [Hash] options
  # @return the computed value 
  #
  def compute_status(options)
    merge_computation_options! options

    status = apply_rules_for :status
    update_attribute(:status, status)

    return self.class.type_cast!(status, :as => :status)
  end

  # Default options for the computations helpers.
  #
  # @param [Hash] options
  # @option options [true, false] :force (false)
  #   and refresh the value
  # @return [Hash]
  #
  def merge_computation_options!(options)
    {
      :force => false
    }.merge(options)
  end

  # Defines and applies the rules.
  #
  # @param [Symbol] what :score, :status
  # @raise [ArgumentError] if no rules are matched
  #
  def apply_rules_for(what)
    case what
    
    when :score
      ( -2 * need - greed + loyalty )

    when :status
      score >= loot_machine.loot_statuses.map(&:score).max ? 'need' : 'greed'
    
    else
      raise ArgumentError, "Computation rules for #{what} are not defined."
    end
  end

  # Type cast a value, given an attribute type
  #
  # @example
  #
  #   type_cast!(1, :as => :score) # => 1.0 for :score is a Float
  #
  # @param [Object] value
  # @param [Hash] options
  # @option options [Symbol] :as
  # @return [Object] the type casted value
  #
  def self.type_cast!(value, options)
    self.columns_hash[options[:as].to_s].type_cast(value)
  end
end
