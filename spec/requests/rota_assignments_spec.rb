require 'rails_helper'

RSpec.describe RotaAssignmentsController, type: :request do
  let!(:source_date){ Date.today }
      
  before do
    5.times do |i|
      FactoryBot.create :rota_assignment, slot: 'am', date: source_date + i.days
      FactoryBot.create :rota_assignment, slot: 'pm', date: source_date + i.days
    end
  end
  
  describe "#index" do
    context "when I request with start and end dates" do
      before do
        get rota_assignments_path(start_date: source_date + 1.day, end_date: source_date + 3.days, format: :json)
      end

      it 'should return all assignement within date range' do
        json = JSON.parse(response.body)
        expect(json.count).to eq 6
        expect(json.select{|r|r['slot'] == 'am'}.map{|r|r['date']}).to eq([source_date + 1.day, source_date + 2.days, source_date + 3.days].map{|d|d.strftime("%Y-%m-%d")})    
      end
    end
  end

  describe "create_for_dates" do
    context "when I request with a start date before already created assignements" do
      it 'should throw error' do
        expect{post(create_for_dates_rota_assignments_path(format: :json), params: {start_date: source_date - 1.day, end_date: source_date + 2.days})}.to raise_error("No future assignments or updates allowed")
      end
    end
    
    context "when I request with a start date of an already created assignement" do
      it 'should throw error' do
        expect{post(create_for_dates_rota_assignments_path(format: :json), params: {start_date: source_date + 4.days, end_date: source_date + 7.days})}.to raise_error("No future assignments or updates allowed")
      end
    end

    context "when I request with a start date after already created assignements" do
      before do
        post create_for_dates_rota_assignments_path(format: :json), params: {start_date: source_date + 7.days, end_date: source_date + 8.days}
      end

      it 'should create and return assignments' do
        json = JSON.parse(response.body)
        expect(json.count).to eq 4
        expect(RotaAssignment.count).to eq(14)  
      end
    end
  end

end
