json.cache! ['v1', report], expires_in: 10.minutes do
	json.(report, :id, :title, :sections, :template, :users)
end