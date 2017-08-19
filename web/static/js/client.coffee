SSOperhero = (->
  provider = null
  opts =
    loginRequired: ->
      log('Placeholder function. Init SSOperhero with loginRequired function to replace this.')
    loginExpired: (user) ->
      log('login expired. renew for user: ' + JSON.stringify(user))
    loginSuccess: ->
      log('Placeholder function. Init SSOperhero with loginSuccess function to replace this.')
    logoutSuccess: ->
      log('Placeholder function. Init SSOperhero with logoutSuccess function to replace this.')

  extend = (orig, add) ->
    for key, val of add
      orig[key] = val
    orig

  log = console.log.bind(window.console, '[SSOperhero Client]')
  log = (->) if location.hostname isnt 'localhost'

  post = (data) ->
    log("[message out]", data)
    provider.contentWindow.postMessage(data, opts.provider)

  trigger = (type, data) ->
    event = new CustomEvent(type, detail: data)
    window.dispatchEvent(event)

  receiveMessage = (event) ->
    log "[message in]", event.data
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
    log("[storage]", event)
    if SSOperhero.loggedIn()
      opts.loginSuccess()
    else
      opts.logoutSuccess()

  addProviderWindow = ->
    return if document.getElementById('ssoperhero-provider-window')
    provider = document.createElement('iframe');
    provider.id = 'ssoperhero-provider-window'
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

    register: (values) ->
      post(intent: 'register', email: values.email, name: values.name, password: values.password)

    forgotPass: (values) ->
      post(intent: 'forgotPass', login: values.login)

    loggedIn: ->
      t = @token()
      t and t.expires and (t.expires > (new Date())) and t.payload.id

    token: ->
      if localStorage.getItem('token')
        log '[token]', localStorage.getItem('token')
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
