defmodule SSO.ExAdmin.Client do
  use ExAdmin.Register

  register_resource SSO.Client do

    index do
      column :id
      column :name
      column :domain
      actions
    end
  end

end

defimpl ExAdmin.Render, for: SSO.Client do
  def to_string(client), do: client.id
end
