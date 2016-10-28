Sequel.migration do
  change do
    alter_table(:users) do
      add_column :userid, String
    end
  end
end
