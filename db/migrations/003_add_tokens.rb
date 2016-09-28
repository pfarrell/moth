Sequel.migration do
  change do
    create_table(:tokens) do
      primary_key :id
      Bignum      :user_id
      Fixnum      :app_id
      String      :token
      DateTime    :expires
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
