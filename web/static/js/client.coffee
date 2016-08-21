SSOperhero = (->
  provider = null
  opts =
    loginRequired: ->
      log('login required')
    loginExpired: (user) ->
      log('login expired. renew for user: ' + JSON.stringify(user))
    loginSuccess: ->
      log('login succeeded')

  extend = (orig, add) ->
    for key, val of add
      orig[key] = val
    orig

  log = ->
    console.log('[SSOperhero] ' + (JSON.stringify(obj) for obj in arguments).join(', '))

  post = (data) ->
    provider.contentWindow.postMessage(data, opts.provider)

  trigger = (type, data) ->
    event = new CustomEvent(type, detail: data)
    window.dispatchEvent(event)

  receiveMessage = (event) ->
    switch event.data.intent
      when 'token:set'
        login = !localStorage.getItem('token')
        localStorage.setItem('token', event.data.value)
        if login
          opts.loginSuccess()
      when 'token:clear'
        localStorage.removeItem('token')
        opts.logoutSuccess()
      when 'error'
        switch event.data.value
          when 'must log in again'
            opts.loginExpired(event.data.user)

  receiveStorage = (event) ->
    if SSOperhero.loggedIn()
      opts.loginSuccess()
    else
      opts.logoutSuccess()

  addProviderWindow = ->
    provider = document.createElement('iframe');
    provider.src = opts.provider
    provider.style.width = provider.style.height = '0'
    provider.style.border = '0'
    document.body.appendChild(provider)

  {
    init: (options) ->
      opts = extend(opts, options)

      window.addEventListener('message', receiveMessage, false)
      window.addEventListener('storage', receiveStorage, false)

      addProviderWindow()

      unless SSOperhero.loggedIn()
        opts.loginRequired()

    login: (values) ->
      post(intent: 'login', login: values.login, password: values.password)

    logout: ->
      post(intent: 'logout')

    loggedIn: ->
      t = @token()
      t and t.expires and (t.expires > (new Date())) and t.payload.id and t.payload.sub is "User"

    token: ->
      if localStorage.getItem('token')
        bits = localStorage.getItem('token').split('.')
        payload = JSON.parse(atob(bits[1]))
        expires = new Date()
        expires.setTime(payload.exp * 1000);
        {
          header: JSON.parse(atob(bits[0])),
          payload: payload,
          signature: bits[2],
          expires: expires
        }
      else
        { }

    raw_token: ->
      localStorage.getItem('token')
  }
)()
