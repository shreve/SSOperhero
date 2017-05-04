Web
===

This directory is the bulk of the app, including all code related to the web-accessible parts of the app.

| File | Description |
|------|-------------|
| web.ex | Defines all components, models, controllers, views, router, and channel by way of importing and aliasing other modules. These components are used by `use Ssoperhero.Web, :component`. |
| router.ex | Defines all the routes available to the app, and does some basic header manipulation/filtering via pipelines. |
| gettext.ex | Enables Internationalization via gettext library. |
| admin/ | Contains definitions of objects available to ExAdmin |
| channels/ | Contains definitions for websocket channel connections |
| controllers/ | Contains definitions for modules that accept parameters, have models do work, and render views to return a response |
| models/ | Contains definitions of ecto database-backed models that query and validate changesets of data |
| static/ | Contains static assets that accompany the app. May include precompileable assets, like coffeescript or sass. |
| templates/ | Contains markup with embeded elixir which will be rendered by views to produce the response |
| views/ | Contains files that provide definitions for the `render` function to be made available in controllers. This allows the use of pattern matching to select the correct response without involving the controller in that decision. |
