module.exports = {
  paths: {
    watched: [
      "web/static"
    ],
    public: "priv/static"
  },

  files: {
    javascripts: {
      joinTo: {
        "js/app.js": /^(web\/static\/js)|(node_modules)/,
        "js/client.js": ["web/static/js/client.coffee"],
        "js/provider.js": ["web/static/js/provider.coffee"],
        "js/ex_admin_common.js": ["web/static/vendor/ex_admin_common.js"],
        "js/admin_lte2.js": ["web/static/vendor/admin_lte2.js"],
        "js/jquery.min.js": ["web/static/vendor/jquery.min.js"],
      }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": /^(web\/static\/css)/,
        "css/admin_lte2.css": ["web/static/vendor/admin_lte2.css"],
        "css/active_admin.css.css": ["web/static/vendor/active_admin.css.css"],
      },
      order: {
        after: ["web/static/css/app.css"] // concat app.css last
      }
    },
  },

  plugins: {
    coffeescript: {
      bare: true
    }
  }
}
