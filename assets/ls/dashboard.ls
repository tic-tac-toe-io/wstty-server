# $ '.collapse' .collapse!

class AgentPanel
  (@data, @index) ->
    return

  render: ->
    {ttt, id, runtime, iface, os, uid, cc, uptime, geoip} = @data
    {ipv4, mac, software_version, socketio_version, protocol_version} = cc
    {profile, profile_version, sn} = ttt
    {node_version, node_arch, node_platform}  = runtime
    {ip} = geoip
    geolocation = geoip.data['ipstack.com']
    sio = ""
    sio = ", sio-#{socketio_version}" if socketio_version? and socketio_version isnt "unknown"
    vinfo = profile_version
    vinfo = "#{profile_version} (<small>#{software_version}</small>)" if software_version? and software_version isnt "unknown"
    ninfo = "#{ipv4}<br>#{ip}"
    uptime = humanizeDuration uptime, largest: 3, round: true, units: <[y mo w d h m s]>
    {hostname} = os
    cid = "collapse_#{id}"
    hid = "heading_#{id}"
    pid = "accordion_#{profile}"
    sn = hostname unless sn? and sn isnt ""
    # collapse-style = if @index == 0 then "collapse in" else "collapse"
    collapse-style = "collapse in"
    return """
      <div class="panel panel-default">
        <div class="panel-heading" role="tab" id="#{hid}">
          <h4 class="panel-title">
            <a role="button" data-toggle="collapse" data-parent="\##{pid}" href="\##{cid}" aria-expanded="true" aria-controls="#{cid}">
              #{id} (#{sn})
            </a>
          </h4>
        </div>
        <div id="#{cid}" class="panel-collapse #{collapse-style}" role="tabpanel" aria-labelledby="#{hid}">
          <div class="panel-body">
            <table class="table table-hover">
              <tbody>
                <tr><td>system</td><td>
                  <small>
                    <p>hostname: <strong>#{hostname}</strong></p>
                    <p>private: <strong>#{ipv4}</strong></p>
                    <p>public: <strong>#{ip}</strong></p>
                    <p>uptime: #{uptime}</p>
                  </small>
                  </td>
                  <td><small>
                    <p>#{node_platform}-#{node_arch}</p>
                    <p>#{mac}</p>
                    <p>#{geolocation.location.country_flag_emoji} #{geolocation.region_name}, #{geolocation.country_name}, #{geolocation.continent_name} (<a href="https://maps.google.com?z=14&ll=#{geolocation.latitude},#{geolocation.longitude}">map</a>)</p>
                    <p>#{geolocation.time_zone.id} (<strong>#{geolocation.time_zone.code}</strong>)</p>
                  </small></td>
                  </tr>
                <tr><td>configurations</td><td>
                  <small>
                    <p>profile: <strong>#{profile_version}</strong></p>
                    <p>app: <strong>#{software_version}</strong></p>
                    <p>nodejs: <strong>#{node_version}</strong></p>
                    <p>socket.io: #{socketio_version}</p>
                  </small>
                  </td>
                  <td><small>
                    <p>#{protocol_version}</p>
                  </small></td>
                  </tr>
                <tr><td></td><td></td><td></td></tr>
              </tbody>
            </table>
            <button class="btn btn-info btn-xs" id="agent_button_console_#{uid}">
              <span class="glyphicon glyphicon-log-in" aria-hidden="true"></span>
              Console
            </button>
            <button class="btn btn-warning btn-xs" id="agent_button_reboot_#{uid}" disabled="disabled">
              <span class="glyphicon glyphicon-refresh" aria-hidden="true"></span>
              Reboot
            </button>
            <button class="btn btn-success btn-xs" id="agent_button_upgrade_#{uid}" disabled="disabled">
              <span class="glyphicon glyphicon-upload" aria-hidden="true"></span>
              Upgrade
            </button>
          </div>
        </div>
      </div>
    """


class AgentsContainer
  (@agent-panels, @profile) ->
    return

  render: ->
    {agent-panels, profile} = @
    pid = "accordion_#{profile}"
    panels = [ a.render! for id, a of agent-panels ]
    return """
      <div class="panel-group" id="#{pid}" role="tablist" aria-multiselectable="true">
        #{panels.join '\n'}
      </div>
    """


class ProfilePanel
  (@profile, @agents, @active) ->
    @agent-panels = [ new AgentPanel a, i for let a, i in agents ]
    @agent-container = new AgentsContainer @agent-panels, profile
    return

  render-tab: ->
    {agent-container, active, profile} = @
    active-class = if active then "active" else ""
    return """
      <li class="#{active-class}" role="presentation">
        <a href="\##{profile}" aria-controls="#{profile}" data-toggle="tab" role="tab">
          #{profile}
        </a>
      </li>
    """

  render-panel: ->
    {agent-container, active, profile} = @
    active-class = if active then "active" else ""
    return """
      <div class="tab-pane #{active-class}" id="#{profile}" role="tabpanel">
        #{agent-container.render!}
      </div>
    """


button-onclick-currying = (uid, action, dummy) -->
  return window.context.perform-action uid, action


class AgentDashboard
  (@context) ->
    profile-panels = @profile-panels = []
    {profiles} = context
    first-active = yes
    for name, p of profiles
      console.log "#{name} profile-panel: #{first-active}"
      pp = new ProfilePanel name, p, first-active
      profile-panels.push pp
      first-active := no if first-active
    return

  render: ->
    {profile-panels} = @
    tabs = [ pp.render-tab! for pp in profile-panels ]
    tab-head = """
      <ul class="nav nav-tabs" role="tablist">
        #{tabs.join '\n'}
      </ul>
    """
    panels = [ pp.render-panel! for pp in profile-panels ]
    tab-body = """
      <div class="tab-content">
        #{panels.join '\n'}
      </div>
    """
    return tab-head + tab-body

  show: ->
    text = @.render!
    ads = $ "\#agent-dashboard"
    ad = ads[0]
    ad.innerHTML = text
    buttons = $ "[id^=agent_button]"
    for b in buttons
      id = b.id
      tokens = id.split '_'
      action = tokens[2]
      uid = parseInt tokens[3]
      f = button-onclick-currying uid, action
      b.onclick = f



class ContextManager
  (@data) ->
    @profiles = {}
    @profile-list = []
    return

  process-data: ->
    {profiles, profile-list, agent-panels, data} = @
    for let a, i in data
      {system, cc, uptime, geoip} = a
      {ttt, id, runtime, iface} = system
      {profile, profile_version} = ttt
      {node_version, node_arch}  = runtime
      if iface? and iface.iface?
        {ipv4, mac} = iface.iface
      else
        ipv4 = "unknown"
        mac = "unknown"
      console.log "uptime: #{uptime}, cc => #{JSON.stringify cc}"
      console.log "system => #{JSON.stringify system}"
      xs = {} <<< system
      xs.cc = cc
      xs.uid = i
      xs.uptime = uptime
      xs.geoip = geoip
      profile-list.push profile
      profiles[profile] = [] unless profiles[profile]?
      profiles[profile].push xs

  perform-action: (uid, action) ->
    a = @data[uid]
    # console.log "perform-action: #{action} => #{JSON.stringify a}"
    {id, system} = a
    {hostname} = system.os
    xs = $ '\#login-agent-id'
    xs[0].value = id
    xs = $ '\#login-modal-label'
    xs[0].innerHTML = "Login #{hostname}"
    lms = $ '\#loginModal'
    lms.modal!
    return console.log "button[#{id}] => #{action}"



class TerminalPanel
  (@id, @username, @password, @cols, @rows) ->
    @performed = no
    @delay-destroy = no
    @delay-ms = 5000ms
    return

  perform: ->
    return if @performed
    self = @
    @performed = yes
    {id, username, password, cols, rows} = @

    xs = $ '\#term-container'
    xs[0].hidden = no
    xs = $ '\#terminal-title'
    xs[0].innerHTML = "#{id}"

    REQ_TTY =
      type: \req-tty
      params:
        type: \pty
        options:
          cols: cols
          rows: rows

    xs = $ '\#term'
    document.title = "#{id} terminal"
    document.term = term = new Terminal do
      cols: cols
      rows: rows
      useStyle: yes
      screenKeys: yes
      cursorBlink: yes
    console.log "term = #{term}"
    term.open xs[0]
    term.write "\x1b[31mWelcome to #{id}\x1b[m\r\n"

    {pathname, host, protocol} = window.location
    url = "#{protocol}//#{host}/terminal"
    console.log "websocket is connecting to #{url}"

    s = io.connect url
    s.on \connect, ->
      console.log "websocket is connected"
      return s.emit \authentication, username: username, password: password

    term.on \data, (data) -> s.emit \tty, data
    s.on \tty, (chunk) -> document.term.write chunk

    s.on \authenticated, ->
      term.write "accepted user: \x1b[33m#{username}\x1b[m\r\n"
      console.log "websocket is authenticated"
      REQ_TTY.id = id
      s.emit \command, JSON.stringify REQ_TTY

    s.on \err, (err) ->
      term.write "unexpected error: \x1b[34m#{err}\x1b[m\r\n"
      term.write "the page will be reload in 20s...\r\n"
      s.disconnect!
      self.delay-ms = 20000ms
      self.delay-destroy = yes

    s.on \unauthorized, (err) ->
      console.log "websocket is unauthorized, err: #{err}"
      term.write "invalid username or password, reload the page in 5 seconds\r\n"
      self.delay-destroy = yes

    s.on \disconnect, ->
      {delay-destroy, delay-ms} = self
      f = ->
        document.term.destroy!
        location.reload true
      if delay-destroy then setInterval f, delay-ms else f!



opts = url: '/api/v1/a/agents?format=advanced'
$.ajax opts .success (data, text-status, xhr) ->
  # console.log "data = #{JSON.stringify data}"
  data = window.aaa = data.data
  context = window.context = new ContextManager data
  context.process-data!
  agent-dashboard = window.agent-dashboard = new AgentDashboard context
  agent-dashboard.show!


xs = $ '\#term-container'
xs[0].hidden = yes


xs = $ '\#login-button'
xs[0].onclick = ->
  xs = $ '\#login-agent-id'
  agent-id = xs[0].value
  xs = $ '\#login-username'
  username = xs[0].value
  xs = $ '\#login-password'
  password = xs[0].value
  xs = $ '\#login-term-cols'
  cols = parseInt xs[0].value
  xs = $ '\#login-term-rows'
  rows = parseInt xs[0].value
  console.log "login #{agent-id} with username `#{username}` and password `#{password}`"
  lms = $ '\#loginModal'
  lms.modal \hide
  xs = $ '\#dashboard'
  xs[0].hidden = yes

  terminal = window.terminal = new TerminalPanel agent-id, username, password, cols, rows
  terminal.perform!



