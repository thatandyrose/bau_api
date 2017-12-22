class RotaAssignment < ApplicationRecord
  belongs_to :developer

  scope :for_date_range, -> (start_date, end_date) {
    where(date: start_date..end_date)
  }

  scope :ascending, -> { order(date: :asc) }

  scope :am, -> { where(slot: 'am') }
  scope :pm, -> { where(slot: 'pm') }

  validates :developer, presence: true
  validates_inclusion_of :slot, in: %w( am pm )
end
