FactoryGirl.define do
  factory :template do
    name "MyString"
	design "MyText"
	private_world false
	private_group false
	group_id 1
	group_edit false
	group_editors "MyText"
  end
end
