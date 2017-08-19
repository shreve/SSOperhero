var SSOperhero;

SSOperhero = (function() {
  var data_to_query, log, login, logout, opts, post, receive_message, register, request, requestToken;
  opts = {};
  request = function(opt) {
    var r;
    log('[request]', opt);
    r = new XMLHttpRequest();
    r.open(opt.method, opt.url, true);
    r.setRequestHeader('X-Origin', document.referrer);
    r.onload = function() {
      var data, ref;
      data = JSON.parse(r.responseText);
      if ((200 >= (ref = r.status) && ref < 400)) {
        return opt.success(data);
      } else {
        return opt.error(data);
      }
    };
    r.onerror = function() {
      return post({
        intent: 'error',
        value: r
      });
    };
    if (opt.method === 'GET') {
      return r.send();
    } else {
      r.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
      return r.send(data_to_query(opt.data));
    }
  };
  log = console.log.bind(window.console, '[SSOperhero Provider]');
  requestToken = function() {
    return request({
      url: '/session',
      method: 'GET',
      success: function(data) {
        return post({
          intent: 'token:set',
          value: data.token
        });
      },
      error: function(data) {
        switch (data.error) {
          case "not logged in":
            return post({
              intent: 'token:clear'
            });
          case "must log in again":
            return post({
              intent: 'error',
              value: data.error,
              user: data.user
            });
          default:
            return post({
              intent: 'error',
              value: data.error
            });
        }
      }
    });
  };
  login = function(login, password) {
    if (!!login && !!password) {
      return request({
        url: '/login',
        method: 'POST',
        data: {
          user: {
            login: login,
            password: password
          }
        },
        success: function(data) {
          return post({
            intent: 'token:set',
            value: data.token
          });
        },
        error: function(data) {
          return post({
            intent: 'error',
            value: data.error,
            user: data.user
          });
        }
      });
    }
  };
  register = function(data) {
    if (!data.name && data.email && data.password) {
      return;
    }
    return request({
      url: '/register',
      method: 'POST',
      data: {
        user: {
          email: data.email,
          name: data.name,
          password: data.password
        }
      },
      success: function(data) {
        log(data);
        return post({
          intent: 'token:set',
          value: data.token
        });
      }
    });
  };
  logout = function() {
    return request({
      url: '/logout',
      method: 'GET',
      success: function(data) {
        return post({
          intent: 'token:clear'
        });
      }
    });
  };
  receive_message = function(event) {
    log("[message in]", event.data);
    switch (event.data.intent) {
      case 'token:get':
        console.log('token:get');
        return requestToken();
      case 'login':
        return login(event.data.login, event.data.password);
      case 'logout':
        return logout();
      case 'register':
        return register(event.data);
    }
  };
  post = function(message) {
    log("[message out]", message);
    if (opts.client_url) {
      return parent.postMessage(message, opts.client_url);
    }
  };
  data_to_query = function(data, prefix) {
    var values;
    values = Object.keys(data).map(function(key) {
      var value;
      value = data[key];
      if (data.constructor === Array) {
        key = prefix + "[]";
      }
      if (data.constructor === Object) {
        key = prefix ? prefix + "[" + key + "]" : key;
      }
      if (typeof value === "object") {
        return data_to_query(value, key);
      } else {
        return key + "=" + (encodeURIComponent(value));
      }
    });
    return [].concat.apply([], values).join('&');
  };
  return {
    init: function(options) {
      opts = options;
      window.addEventListener('message', receive_message, false);
      return requestToken();
    }
  };
})();

//# sourceMappingURL=provider.js.map
