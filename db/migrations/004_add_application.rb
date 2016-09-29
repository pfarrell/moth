Sequel.migration do
  change do
    create_table(:apps) do
      primary_key :id
      String      :name
      String      :redirect
      String      :homepage
      DateTime    :created_at
      DateTime    :updated_at
    end

    create_table(:apps_users) do
      primary_key :id
      Fixnum      :app_id
      Bignum      :user_id
      DateTime    :created_at
      DateTime    :updated_at
    end

  end
end
