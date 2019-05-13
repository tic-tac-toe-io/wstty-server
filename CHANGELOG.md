# Changelog

## [1.0.2] - 2019-05-13
### Added
- Apply [CHANGELOG](https://keepachangelog.com/en/1.0.0/) format in repository

### Changed
- Fix server url retrieval for localhost connections
- Disable server statistical report (iw-client) to legacy influxdb (v0.8.8) by default

## [1.0.1] - 2019-01-01

- Improve Terminal Web UI
- Retrieve geolocation information for each connected agent

## [1.0.0] - 2019-01-01

- v1.0 with `lookup-next-server` feature

## [0.9.9] - 2019-01-01

- fix connection info update issue

## [0.9.8] - 2019-01-01

- `filemgr`: support downloadFile operation

## [0.9.7] - 2019-01-01

- `bash-by-server`: refactorying web api implementation, and add `operation` to _configs_
- `bash-by-server`: move `apply-image` to TOE specific api: `/:id/yapps-scripts/v3/apply-image`

## [0.9.6] - 2019-01-01

- `bash-by-server`: support alias operation `apply-image`

## [0.9.5] - 2019-01-01

- `filemgr`: support readFile operation

## [0.9.4] - 2019-01-01

- `filemgr`: support env operation

## [0.9.3] - 2019-01-01

- `filemgr`: support readdir operation

## [0.9.2] - 2019-01-01

- Fix command-sock typo issue

## [0.9.1] - 2019-01-01

- `bash-by-server`: support progress indication to receiver server (http callback) via UnixSock server specified by environment variable: `WSTTY_AGENT_UNIXSOCK`
- `bash-by-server`: use **PUT** method to send execution log to receiver server (http callback) via multipart form
- `bash-by-server`: use **POST** method to forward progress indication event to receiver server (http callback)

## [0.9.0] - 2019-01-01

- Implement `bash-by-server` service

## [0.8.2] - 2019-01-01

- Find other ipv4 address from all available interfaces when ipv4 is `unknown`

## [0.8.1] - 2019-01-01

- Apply `uuid-v4` to generate request-id by default in HTTP-Relay. (Or specify `_uuid==false` to disable uuid)

## [0.8.0] - 2019-01-01

- Add `_uuid` option to query string of HTTP Relay APIs, to force to use uuid-v4 as task id to avoid gateway timeout issue

## [0.7.7] - 2019-01-01

- Add `instance_id` to communication context (cc) object when sending back to agent after registration

## [0.7.6] - 2019-01-01

- Unify output logs for `agent-http-service`
- Implement `HTTP_BY_AGENT_ERR_SERVER_TIMEOUT`

## [0.7.5] - 2019-01-01

- Implement RPC for HTTP/REST apis of TOE apps based on `AGENT_EVENT_HTTP_BY_SERVER`
  - `/api/v1/toe/[id]/toe-agent/v3`
  - `/api/v1/toe/[id]/sensor-web/v3`
  - `/api/v1/toe/[id]/sensor-web/v1`

## [0.7.4] - 2019-01-01

- Use yapps to load `package.json` instead of pkginfo

## [0.7.3] - 2019-01-01

- Implement `AGENT_EVENT_HTTP_BY_SERVER`

## [0.7.1] - 2019-01-01

- Improve pkginfo detection with directly-access to `module` variable by skipping browserify manipulation (storing `module` in the `global.yac-context` variable)

## [0.7.0] - 2019-01-01

- Implement protocol 0.2.0
- Improve mac address and ip address detection
- Improve web UI with humanized uptime and protocol information

## [0.6.3] - 2019-01-01

- Add passport for HTTP Basic Authentication

## [0.6.2] - 2019-01-01

- Replace `prelude-ls` with lodash
- Remove unused module dependencies
  - `jade`
  - `serve-favicon`
  - `multer`
  - `method-override`
  - `express-partial-response`
- Upgrade `pug` from 2.0.0-rc4 to 2.0.3

## [0.6.1] - 2019-01-01

- Upgrade socketio-auth from 0.0.4 to 0.1.0
- Replace [jade](http://jade-lang.com/) with [pug](https://github.com/pugjs/pug)

## [0.6.0] - 2019-01-01

- Upgrade [socket.io](https://github.com/socketio/socket.io) from 1.3.7 to 2.0.4

## [0.5.6] - 2019-01-01

- Update system metrics to sysadmin database

## [0.5.5] - 2019-01-01

- Update settings for replacing web0/monitor with hub000

## [0.5.4] - 2019-01-01

- Slightly change the UI styles for web-terminal
  - `SourceCodePro-ExtraLight` is added to the 1st element of default fonts
  - Change font size to 10px
  - Change FG and BG colors for terminal

## [0.5.3] - 2019-01-01

- Correctly clean up resources for duplicate agent error
- Submit `[db]:/[id]/tic/wstty/agent/duplicate` data every 60s

## [0.5.2] - 2019-01-01

- Use incremental uptime updater
- Force underlying socket connection to be closed when duplicated agent exists (close the newer one)
- Dump more information when duplicate agent takes place

## [0.5.1] - 2019-01-01

- Fix state-updater bug

## [0.5.0] - 2019-01-01

- Add more metrics with iw-client to update influxdb.
  - `[db]:/[id]/tic/wstty/user.[username]/uptime`
  - `[db]:/[id]/tic/wstty/user.[username]/state`
  - `api:/[site]/wstty/system/agents/total`
  - `api:/[site]/wstty/system/agents/onlines`
  - `api:/[site]/wstty/system/agents/offlines`
- Improve verbose messages

## [0.4.3] - 2019-01-01

- Ensure the index of short-connection instance is printed out when disconnection.

## [0.4.2] - 2019-01-01

- Fix short disconnection issue

## [0.4.1] - 2019-01-01

- Add index and username of web terminal pairing

## [0.4.0] - 2019-01-01

- Improve logging messages
- Add system websocket channel for monitoring and management purpose
- Add sensorweb-client to update number of connected agents and the uptime of each agent session

## [0.2.2] - 2019-01-01

- Fix a critical bug that is caused by mis-deleting the listener `me-on-depair` in agent-mgr

## [0.2.1] - 2019-01-01

- Improve state consistency when `disconnect` event takes place before `pair` event

## [0.2.0] - 2019-01-01

- Refactor packet protocol in order to support both `pty.spawn` and `child_process.spawn`

## [0.1.6] - 2019-01-01

- Disable pretty-json outputs

## [0.1.5] - 2019-01-01

- Replace uart-board with communicator
- Replace parser with legacy.ls

## [0.1.0] - 2019-01-01

Initial version of SensorWeb on yapps-tt framework.