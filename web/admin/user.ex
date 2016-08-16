defmodule Ssoperhero.ExAdmin.User do
  use ExAdmin.Register

  register_resource Ssoperhero.User do

    filter except: [:encrypted_password]

    index do
      column :id
      column :name
      column :email
      column :last_login_at
    end

    form user do
      inputs do
        input user, :name
        input user, :email
        input user, :password
      end
    end
  end
end
