SSOperhero = (->
  provider = null
  opts = {}

  post = (data) ->
    provider.contentWindow.postMessage(data, opts.provider)

  trigger = (type, data) ->
    event = new CustomEvent(type, detail: data)
    window.dispatchEvent(event)

  receive_message = (event) ->
    switch event.data.intent
      when 'set_token'
        localStorage.setItem('token', event.data.value)
      when 'login:success'
        localStorage.setItem('token', event.data.value)
        trigger('ssoperhero:login_success')
      when 'error'
        switch event.data.value
          when 'must log in again'
            trigger('ssoperhero:login_expired', event.data.user)
          else
            trigger('ssoperhero:error', event.data)

  {
    init: (options) ->
      opts = options
      provider = document.createElement('iframe');
      provider.onload = ->
        post(intent: 'token_present', value: !!localStorage.getItem('token'))
      provider.src = opts.provider
      provider.style.width = provider.style.height = '0'
      provider.style.border = '0'
      document.body.appendChild(provider)

      window.addEventListener('message', receive_message, false)

    login: (values) ->
      post(intent: 'login', login: values.login, password: values.password)

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
  }
)()
