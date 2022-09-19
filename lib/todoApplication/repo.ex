defmodule TodoApplication.Repo do
  use Ecto.Repo,
    otp_app: :todoApplication,
    adapter: Ecto.Adapters.Postgres
end
