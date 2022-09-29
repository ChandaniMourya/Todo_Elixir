defmodule TodoApplicationWeb.PageController do
  use TodoApplicationWeb, :controller
  alias TodoApplication.Todos.Todo
  alias TodoApplication.Repo
  import Ecto.Query, only: [from: 2]

  def save(conn, params) do

    title = params["title"]
    desc = params["description"]
    priority = params["priority"]
    # IO.inspect("###########/######SAVE###################")
    # IO.inspect(title)
    if is_number(title) or is_number(desc) or is_number(priority) do
      put_flash(conn, :error, "Data is not inserted") |> redirect(to: "/")
      # send_resp(conn, 400, Jason.encode!(%{"message" => "Data is not inserted"}))
    else
      Repo.insert(%Todo{title: title, description: desc, priority: priority})
      put_flash(conn, :info, "Data is inserted") |> redirect(to: "/")
    end
  end

  def get(conn, _) do
   select = Repo.all(Todo)
    struct =
      Enum.map(select, fn x ->
        %{description: x.description, title: x.title, priority: x.priority, id: x.id}
      end)

    IO.inspect(struct)
    render(conn, "index.html", get: struct)
  end

  def update(conn, updated_value) do
    updatevalue = updated_value["title"]
    updatedescriptionvalue = updated_value["description"]
    id = updated_value["id"]
      # IO.inspect(updatevalue);
      # IO.inspect(id);
      # IO.inspect(updatedescriptionvalue);

    # Create a query
    query =
      from(c in Todo,
        where: c.id == ^id,
        or_where: c.title == ^updatevalue,
        or_where: c.description == ^updatedescriptionvalue
      )

    select = Repo.one(query)
    change = Todo.changeset(select, %{title: updatevalue , description: updatedescriptionvalue})
    case is_map(select) do
      true ->
        case Repo.update(change) do
          {:ok, _} -> put_flash(conn, :info, "updated") |> redirect(to: "/")
          {:error, _} -> put_flash(conn, :error, "title not found") |> redirect(to: "/")
        end
      _ ->
      put_flash(conn, :info, "command not found") |> redirect(to: "/")
    end
  end

  # Delete Request
  def delete(conn, params) do
    delete = params["id"]
    IO.inspect(delete)

    multiitemsdelete = Repo.all(from(c in Todo, where: c.id == ^delete))
    delectquery = Enum.map(multiitemsdelete, fn x -> Repo.delete(x) end)
    eledelete = Enum.count(multiitemsdelete)
    querydele = Enum.count(delectquery)

    if querydele > 0 do
      if eledelete == querydele do
        put_flash(conn, :info, "Row is delete") |> redirect(to: "/")
      else
        put_flash(conn, :error , "mismatch the data") |> redirect(to: "/")
      end
    else
      put_flash(conn, :error, "Data is not in table ") |> redirect(to: "/")
    end
  end


end
