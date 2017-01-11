class Stance < ActiveRecord::Base
  include HasMentions

  ORDER_SCOPES = ['newest_first', 'oldest_first', 'priority_first', 'priority_last']

  is_mentionable  on: :reason

  belongs_to :poll, required: true
  belongs_to :poll_option, required: true
  belongs_to :participant, polymorphic: true, required: true

  update_counter_cache :poll, :stances_count

  scope :latest, -> { where(latest: true) }

  scope :newest_first,   -> { order(created_at: :desc) }
  scope :oldest_first,   -> { order(created_at: :asc) }
  # scope :voters_a_to_z,  -> { joins(:participant).order('participants.name DESC') }
  # scope :voters_z_to_a,  -> { joins(:participant).order('participants.name ASC') }
  scope :priority_first, -> { joins(:poll_option).order('poll_options.priority ASC') }
  scope :priority_last,  -> { joins(:poll_option).order('poll_options.priority DESC') }


  delegate :group, to: :poll, allow_nil: true
  def author
    participant
  end
end