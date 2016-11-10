defmodule HelloPhoenix.Repo do
  use Ecto.Repo, otp_app: :hello_phoenix
  use Scrivener, page_size: 10
end
