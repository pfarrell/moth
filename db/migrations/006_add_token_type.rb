Sequel.migration do
  change do
    alter_table(:tokens) do
      add_column :type, String
    end
  end
end
