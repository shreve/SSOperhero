defmodule SSO.Plugs.Client do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    case SSO.Client.find_by_conn(conn) do
      {:ok, client} ->
        assign(conn, :client, client)
      {:error, _msg} ->
        assign(conn, :client, nil)
    end
  end
end
