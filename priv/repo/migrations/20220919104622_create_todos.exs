defmodule TodoApplication.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :description, :string
      add :priority, :string

      timestamps()
    end
  end
end
