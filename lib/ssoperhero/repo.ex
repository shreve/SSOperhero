defmodule Ssoperhero.Repo do
  use Ecto.Repo, otp_app: :ssoperhero
  use Scrivener, page_size: 10
end
