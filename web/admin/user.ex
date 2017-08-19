defmodule SSO.ExAdmin.User do
  use ExAdmin.Register

  register_resource SSO.User do

    filter except: [:encrypted_password]

    index do
      column :id
      column :name
      column :email
      column :client
      column :last_login_at
    end

    form user do
      inputs do
        input user, :name
        input user, :email
        input user, :password
        input user, :client
      end
    end
  end
end
