class RotaAssigner
  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
  end

  def assign_developers
    # check there are no assignments today or in the future
    raise "No future assignments or updates allowed" if has_future_assignements? || start_date_assignments.size > 1
    (@start_date..@end_date).each do |date|
      assign_developers_for_date date
    end

    RotaAssignment.for_date_range(@start_date, @end_date)    
  end

  private

  def assign_developers_for_date(date)
    # get developers who have not had any assignments yesterday
    developers = Developer.with_no_assignment_for(date - 1.day).order_by_least_active.limit(2)

    if developers.first && RotaAssignment.where("date > ?", date).am.first
      developers.first.rota_assignments.create! slot: 'pm', date: date
    else
      developers.each_with_index do |dev, i|
        dev.rota_assignments.create! slot: (i == 0 ? 'am' : 'pm'), date: date
      end
    end
  end

  def has_future_assignements?
    RotaAssignment.where("date > ?", @start_date).count > 0
  end

  def start_date_assignments
    RotaAssignment.where(date: @start_date)
  end
end