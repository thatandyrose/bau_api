require 'rails_helper'

describe RotaAssigner do
  let(:today){ Date.today }
  
  context "when I create an assignment for today" do
    
    context "and there are no past assignement" do
      context "and two developers" do
        before do
          2.times do
            FactoryBot.create :developer
          end
          RotaAssigner.new(start_date: today, end_date: today).assign_developers
        end
        
        it 'should create a am and pm assignement with different developers' do
          expect(RotaAssignment.count).to eq(2)
          expect(RotaAssignment.pluck(:developer_id).uniq.count).to eq(2)
          expect(RotaAssignment.pluck(:slot).uniq.count).to eq(2)
        end  
      end
      
      context "and one developer" do
        before do
          FactoryBot.create :developer
          RotaAssigner.new(start_date: today, end_date: today).assign_developers
        end
        
        it 'should create an am assignement only' do
          expect(RotaAssignment.count).to eq(1)
          expect(RotaAssignment.first.slot).to eq('am')
        end  
      end
      
    end

    context "and all developers have done shifts on different previous days" do
      let!(:developers){ 
        3.times.map do
          FactoryBot.create :developer
        end 
      }
      
      before do
        FactoryBot.create :rota_assignment, slot: 'am', developer: developers[2], date: today - 8.days
        FactoryBot.create :rota_assignment, slot: 'pm', developer: developers[0], date: today - 7.days

        FactoryBot.create :rota_assignment, slot: 'am', developer: developers[1], date: today - 6.days

        RotaAssigner.new(start_date: today, end_date: today).assign_developers
      end

      it 'should assign developers by order of amount of time since last shift' do
        new_assignments = RotaAssignment.where(date: today)

        expect(RotaAssignment.count).to eq(5)
        expect(new_assignments.am.first.developer_id).to eq(developers[2].id)
        expect(new_assignments.pm.first.developer_id).to eq(developers[0].id)
      end
    end
    
    context "and two developer have done a shift the day before" do
      let!(:developers){ 
        3.times.map do
          FactoryBot.create :developer
        end 
      }

      before do
        FactoryBot.create :rota_assignment, slot: 'am', developer: developers[0], date: today - 1.day
        FactoryBot.create :rota_assignment, slot: 'pm', developer: developers[1], date: today - 1.day

        RotaAssigner.new(start_date: today, end_date: today).assign_developers
      end
      
      it 'should create a am only assignent with the free developer' do
        expect(RotaAssignment.count).to eq(3)
        expect(RotaAssignment.ascending.last.developer_id).to eq(developers.last.id)
        expect(RotaAssignment.ascending.last.date).to eq(today)
        expect(RotaAssignment.ascending.last.slot).to eq('am')
      end
    end

    context "and two developer have done a shift two days before" do
      let!(:developers){ 
        3.times.map do
          FactoryBot.create :developer
        end 
      }

      before do
        FactoryBot.create :rota_assignment, slot: 'am', developer: developers[0], date: today - 2.days
        FactoryBot.create :rota_assignment, slot: 'pm', developer: developers[1], date: today - 2.days

        RotaAssigner.new(start_date: today, end_date: today).assign_developers
      end
      
      it 'should create a am and pm assignents with any developer' do
        expect(RotaAssignment.count).to eq(4)
      end
    end
    
  end
end
