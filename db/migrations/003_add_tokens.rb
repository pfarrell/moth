Sequel.migration do
  change do
    create_table(:logs) do
      primary_key :id
      Fixnum      :user_id
      String      :action
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
