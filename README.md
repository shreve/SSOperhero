# SSOperhero [WIP]

A general-purpose stack-exchange-esque single-sign-on solution.

**This project has nearly reached MVP status. It is not completely operational yet.**

To start the app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
The more useful admin area is located at [`localhost:4000/admin`](http://localhost:4000/admin),
currently unprotected.

## TODO

  - [ ] Remove HTML frontend in favor of JSON-only
  - [ ] Verify security of credential handoff process
  - [ ] Protect the admin area

## Learn more about the Phoenix framework

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
