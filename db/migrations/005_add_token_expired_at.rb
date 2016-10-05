Sequel.migration do
  change do
    alter_table(:tokens) do
      add_column :expired_at, DateTime
    end
  end
end
