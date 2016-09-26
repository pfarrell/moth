Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String      :email, unique: true
      String      :password
      String      :name
      String      :salt
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
