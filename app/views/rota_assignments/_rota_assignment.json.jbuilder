json.extract! rota_assignment, :id, :slot, :date, :developer_id, :created_at, :updated_at

json.developer do
  json.extract! rota_assignment.developer, :id, :name, :image_url
end
