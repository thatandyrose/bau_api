class Developer < ApplicationRecord
  has_many :rota_assignments

  scope :with_no_assignment_for,  -> (date) {
    where("(select count(rota_assignments.id) from rota_assignments where developer_id = developers.id and date = :date) = 0", date: date)
  }

  scope :order_by_least_active, -> {
    select("(select date from rota_assignments where developer_id = developers.id order by date desc limit 1) as last_date, developers.*").order("last_date asc NULLS first")
  }
end
