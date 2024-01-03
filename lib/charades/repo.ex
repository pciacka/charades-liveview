defmodule Charades.Repo do
  use Ecto.Repo,
    otp_app: :charades,
    adapter: Ecto.Adapters.Postgres
end
