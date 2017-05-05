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

## Project Goals

SSOperhero aims to be the minimum scaffolding for a single-signon solution. You should be able to fork this repo, and make minimal changes to suit your own business needs before you have a shared login mechanism between all your sites, or even for all your clients' sites.

What follows in this section is what will be true when this project is ready (MVP), not necessarily what is true now.

### Network

A network is a group of sites that share a common group of users. A user joins a network and is logged into any site in the network they visit. Networks are what allow a single instance of this app to manage multiple groups of SSO-enabled sites, perfect for an agency managing multiple clientele with multiple sites.

- [ ] A network has many clients
- [ ] A network has many users

### Client

A client is a single website that can receive and digest auth tokens from this source.

- [x] A client has a unique token signature
- [ ] A client belongs to one network
- [ ] A client has many users through its network

### User

A user is an authenticatable person with a login and password.

- [x] A user has an email and a unique username, which can both be used to log in.
- [ ] A user belongs to a network, and can therefore be logged into any client site in the network

### Usage

1. Set up desired networks and clients.
2. Configure every site/app backend to accept JWT as authentication in whatever mechanism you wish.
3. Include the provided client.js file on every page of the desired sites.
   The client provides an API for user creation and logging in.
4. Implement authentication in your app/site however you want based on the token provided by the client.

Protip: `Authentication.fetch_token()` will return the token from localStorage, or load an iframe and try to fetch the user's token from the beacon app. This is helpful for the SSO option, where they have a running session with the beacon from another site, just not the current site.

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
