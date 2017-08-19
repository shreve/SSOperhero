defmodule SSO.Repo do
  use Ecto.Repo, otp_app: :sso
  use Scrivener, page_size: 10
end
