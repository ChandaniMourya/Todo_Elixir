defmodule TodoApplicationWeb.PageController do
  use TodoApplicationWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
