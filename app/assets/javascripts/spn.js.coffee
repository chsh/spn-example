$ ->
  if window.safari && window.safari.pushNotification
    website_push_id = 'YOUR WEBSITE PUSH ID'
    domain_name = 'YOUR DOMAIN NAME'
    token = null
    check_remote_permission = (result) ->
      if result.permission == 'default'
        # initial state
        window.safari.pushNotification.requestPermission(
          'https://' + domain_name + '/spn/push',
          website_push_id, { token: token },
          check_remote_permission
        )
      else if result.permission == 'denied'
        # The user said no.
        alert "Denied to Safari Push Notification."
      else if result.permission == 'granted'
        # Permissin granted.
        alert "Granted to Safari Push Notification."
      else
        alert "unacceptable permission:" + result.permission
    window.request_spn_permission = (params_token) ->
      token = params_token
      result = window.safari.pushNotification.permission(website_push_id)
      check_remote_permission(result)
  else
    window.request_spn_permission = (params_token) ->

