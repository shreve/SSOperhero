SSOperhero = (->
  opts = {}

  request = (opt) ->
    r = new XMLHttpRequest()
    r.open(opt.method, opt.url, true)
    r.setRequestHeader('X-Origin', document.referrer)
    r.onload = ->
      if r.status is 204
        opt.success()
      else
        data = JSON.parse(r.responseText)
        if 200 >= r.status < 400
          opt.success(data)
        else
          opt.error(data)
    if opt.method is 'GET'
      r.send()
    else
      r.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8')
      r.send(opt.data)

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
        data: "user[login]=" + login + "&user[password]=" + password
        success: (data) ->
          post(intent: 'token:set', value: data.token)
        error: (data) ->
          post(intent: 'error', value: data.error, user: data.user)

  logout = ->
    request
      url: '/logout'
      method: 'GET',
      success: (data) ->
        post(intent: 'token:clear')

  receive_message = (event) ->
    switch event.data.intent
      when 'token:get'
        console.log 'token:get'
        requestToken()
      when 'login'
        login(event.data.login, event.data.password)
      when 'logout'
        logout()


  post = (message) ->
    if opts.client_url
      parent.postMessage(message, opts.client_url)

  {
    init: (options) ->
      opts = options
      window.addEventListener('message', receive_message, false);
      requestToken()
  }
)()
