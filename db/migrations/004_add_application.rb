Sequel.migration do
  change do
    create_table(:applications) do
      primary_key :id
      String      :name
      String      :redirect
      String      :homepage
      DateTime    :created_at
      DateTime    :updated_at
    end

    create_table(:applications_users) do
      primary_key :id
      Fixnum      :application_id
      Bignum      :user_id
      DateTime    :created_at
      DateTime    :updated_at
    end

  end
end
