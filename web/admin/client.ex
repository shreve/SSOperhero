defmodule Ssoperhero.ExAdmin.Client do
  use ExAdmin.Register

  register_resource Ssoperhero.Client do

    index do
      column :id
      column :name
      column :domain
      actions
    end
  end
end
