defmodule Brkr.Repo do
  use Ecto.Repo,
    otp_app: :brkr,
    adapter: Ecto.Adapters.Postgres
end
