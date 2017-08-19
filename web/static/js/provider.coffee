SSOperhero = (->
  opts = {}

  request = (opt) ->
    log '[request]', opt
    r = new XMLHttpRequest()
    r.open(opt.method, opt.url, true)
    r.setRequestHeader('X-Origin', document.referrer)
    r.onload = ->
      data = JSON.parse(r.responseText)
      if 200 >= r.status < 400
        opt.success(data)
      else
        opt.error(data)
    r.onerror = ->
      post(intent: 'error', value: r)

    if opt.method is 'GET'
      r.send()
    else
      r.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8')
      r.send(data_to_query(opt.data))

  log = console.log.bind(window.console, '[SSOperhero Provider]')

  requestToken = ->
    request
      url: '/session'
      method: 'GET'
      success: (data) ->
        post(intent: 'token:set', value: data.token)
      error: (data) ->
        switch data.error
          when "not logged in" then post(intent: 'token:clear')
          when "must log in again" then post(intent: 'error', value: data.error, user: data.user)
          else post(intent: 'error', value: data.error)

  login = (login, password) ->
    if !!login and !!password
      request
        url: '/login'
        method: 'POST'
        data:
          user:
            login: login
            password: password
        success: (data) ->
          post(intent: 'token:set', value: data.token)
        error: (data) ->
          post(intent: 'error', value: data.error, user: data.user)

  register = (data) ->
    return if not data.name and data.email and data.password
    request
      url: '/register'
      method: 'POST'
      data:
        user:
          email: data.email
          name: data.name
          password: data.password
      success: (data) ->
        log data
        post(intent: 'token:set', value: data.token)

  logout = ->
    request
      url: '/logout'
      method: 'GET',
      success: (data) ->
        post(intent: 'token:clear')

  receive_message = (event) ->
    log "[message in]", event.data
    switch event.data.intent
      when 'token:get'
        console.log 'token:get'
        requestToken()
      when 'login'
        login(event.data.login, event.data.password)
      when 'logout'
        logout()
      when 'register'
        register(event.data)


  post = (message) ->
    log "[message out]", message
    if opts.client_url
      parent.postMessage(message, opts.client_url)

  data_to_query = (data, prefix) ->
    values = Object.keys(data).map (key) ->
      value = data[key]
      if data.constructor is Array
        key = "#{prefix}[]"
      if data.constructor is Object
        key = if prefix then "#{prefix}[#{key}]" else key

      if typeof value is "object"
        data_to_query(value, key)
      else
        "#{key}=#{encodeURIComponent(value)}"

    [].concat.apply([], values).join('&')

  {
    init: (options) ->
      opts = options
      window.addEventListener('message', receive_message, false);
      requestToken()
  }
)()
