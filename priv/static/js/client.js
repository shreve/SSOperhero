var SSOperhero;

SSOperhero = (function() {
  var addProviderWindow, extend, log, opts, post, provider, receiveMessage, receiveStorage, trigger;
  provider = null;
  opts = {
    loginRequired: function() {
      return log('Placeholder function. Init SSOperhero with loginRequired function to replace this.');
    },
    loginExpired: function(user) {
      return log('login expired. renew for user: ' + JSON.stringify(user));
    },
    loginSuccess: function() {
      return log('Placeholder function. Init SSOperhero with loginSuccess function to replace this.');
    },
    logoutSuccess: function() {
      return log('Placeholder function. Init SSOperhero with logoutSuccess function to replace this.');
    }
  };
  extend = function(orig, add) {
    var key, val;
    for (key in add) {
      val = add[key];
      orig[key] = val;
    }
    return orig;
  };
  log = console.log.bind(window.console, '[SSOperhero Client]');
  if (location.hostname !== 'localhost') {
    log = (function() {});
  }
  post = function(data) {
    log("[message out]", data);
    return provider.contentWindow.postMessage(data, opts.provider);
  };
  trigger = function(type, data) {
    var event;
    event = new CustomEvent(type, {
      detail: data
    });
    return window.dispatchEvent(event);
  };
  receiveMessage = function(event) {
    var login;
    log("[message in]", event.data);
    switch (event.data.intent) {
      case 'token:set':
        login = !localStorage.getItem('token');
        localStorage.setItem('token', event.data.value);
        if (login) {
          return opts.loginSuccess();
        }
        break;
      case 'token:clear':
        localStorage.removeItem('token');
        return opts.logoutSuccess();
      case 'error':
        switch (event.data.value) {
          case 'must log in again':
            return opts.loginExpired(event.data.user);
        }
    }
  };
  receiveStorage = function(event) {
    log("[storage]", event);
    if (SSOperhero.loggedIn()) {
      return opts.loginSuccess();
    } else {
      return opts.logoutSuccess();
    }
  };
  addProviderWindow = function() {
    if (document.getElementById('ssoperhero-provider-window')) {
      return;
    }
    provider = document.createElement('iframe');
    provider.id = 'ssoperhero-provider-window';
    provider.src = opts.provider;
    provider.style.width = provider.style.height = '0';
    provider.style.border = '0';
    return document.body.appendChild(provider);
  };
  return {
    init: function(options) {
      opts = extend(opts, options);
      window.addEventListener('message', receiveMessage, false);
      window.addEventListener('storage', receiveStorage, false);
      addProviderWindow();
      if (!SSOperhero.loggedIn()) {
        return opts.loginRequired();
      }
    },
    login: function(values) {
      return post({
        intent: 'login',
        login: values.login,
        password: values.password
      });
    },
    logout: function() {
      return post({
        intent: 'logout'
      });
    },
    register: function(values) {
      return post({
        intent: 'register',
        email: values.email,
        name: values.name,
        password: values.password
      });
    },
    forgotPass: function(values) {
      return post({
        intent: 'forgotPass',
        login: values.login
      });
    },
    loggedIn: function() {
      var t;
      t = this.token();
      return t && t.expires && (t.expires > (new Date())) && t.payload.id;
    },
    token: function() {
      var bits, expires, payload;
      if (localStorage.getItem('token')) {
        log('[token]', localStorage.getItem('token'));
        bits = localStorage.getItem('token').split('.');
        payload = JSON.parse(atob(bits[1]));
        expires = new Date();
        expires.setTime(payload.exp * 1000);
        return {
          header: JSON.parse(atob(bits[0])),
          payload: payload,
          signature: bits[2],
          expires: expires
        };
      } else {
        return {};
      }
    },
    raw_token: function() {
      return localStorage.getItem('token');
    }
  };
})();

//# sourceMappingURL=client.js.map
