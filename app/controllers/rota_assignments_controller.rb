class RotaAssignmentsController < ApplicationController
  # GET /rota_assignments
  # GET /rota_assignments.json
  def index
    @rota_assignments = RotaAssignment.for_date_range(params[:start_date], params[:end_date])
  end

  # POST /rota_assignments/create_for_dates
  # POST /rota_assignments/create_for_dates.json
  def create_for_dates
    @rota_assignments = RotaAssigner.new(start_date: Date.parse(params[:start_date]), end_date: Date.parse(params[:end_date])).assign_developers
    render :index, status: :created
  end
end
