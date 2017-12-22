json.extract! rota_assignment, :id, :slot, :date, :developer_id, :created_at, :updated_at

json.developer json.extract! rota_assignment.developer, :id, :name, :image_url
