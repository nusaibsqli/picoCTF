window.apiCall = (type, url, data) ->
  $.ajax {url: url, type: type, data: data, cache: false}
  .fail (jqXHR, text) ->
    $.notify "API is offline. :(", "error"

window.redirectIfNotLoggedIn = ->
  apiCall "GET", "/api/user/isloggedin", {}
  .done (data) ->
    switch data["status"]
      when 0
        window.location.href = "/login"

window.redirectIfLoggedIn = ->
  apiCall "GET", "/api/user/isloggedin", {}
  .done (data) ->
    switch data["status"]
      when 1
        window.location.href = "/"

getStyle = (data) ->
  style = "info"
  switch data.status
    when 0
      style = "error"
    when 1
      style = "success"
  return style

window.apiNotify = (data) ->
  style = getStyle data
  $.notify data.message, style

$.fn.apiNotify = (data, configuration) ->
  configuration["className"] = getStyle data
  return $(this).notify(data.message, configuration)

# Source: http://stackoverflow.com/a/17488875
$.fn.serializeObject = ->
   o = {}
   a = this.serializeArray()
   $.each(a, ->
       if o[this.name]
           if !o[this.name].push
               o[this.name] = [o[this.name]]
           o[this.name].push(this.value || '')
       else
           o[this.name] = this.value || ''
   )
   return o
