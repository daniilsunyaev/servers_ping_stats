# Servers Ping Stats

Small app to add and remove hosts to be pinged in the background.

## Setup

Make sure you have `ping`, `postgres`, `redis` installed in your system.

clone repo

```
git clone git@github.com:daniilsunyaev/servers_ping_stats.git
```

Run setup

```
bin/setup
```

<details>
  <summary>Optional checks</summary>

  Runs tests suite if you want:
  ```
  bin/rspec spec
  ```

  If you are crazy pedant, run rubocop checks:
  ```
  bin/rubocop
  ```
</details>

Run redis server

```
redis-server --port 6380
```
You can change port in `.env` file.

Run sidekiq:

```
bin/bundle exec sidekiq
```

One should kick off recurring job that looks over active monitorings:

```ruby
bin/rails c
irb(main):001:0> PingMonitoredHostsJob.perform_later
```

Finally, you can run rais server:

```
bin/rails s
```

## Usage

### Add host to monitored list

required `host: string`

```
curl -X POST -H 'Content-type: application/json' -H 'Accept: application/json' -d '{"host" : "8.8.8.8"}' '127.0.0.1:3000/host_monitorings'

{"id":3,"host":"8.8.8.8","ended_at":null,"created_at":"2021-02-10T10:59:59.672Z","updated_at":"2021-02-10T10:59:59.672Z"}

```
One cannot add same host twice:

```
curl -X POST -H 'Content-type: application/json' -H 'Accept: application/json' -d '{"host" : "8.8.8.8"}' '127.0.0.1:3000/host_monitorings'

{"errors":{"host":["Host is already monitored"]}}
```

### Remove host from monitored list

required `host: string`


```
curl -X POST -H 'Content-type: application/json' -H 'Accept: application/json' -d '{"host" : "8.8.8.8"}' '127.0.0.1:3000/host_monitorings/stop'

{"ended_at":"2021-02-10T11:02:07.576Z","id":3,"host":"8.8.8.8","created_at":"2021-02-10T10:59:59.672Z","updated_at":"2021-02-10T11:02:07.576Z"}
```

### Get monitoring statistics

required `host: string`, `timeframe_starts_at: string` (unix timestamp)
optional `timeframe_ends_at: string` (unix timestamp, replaced with current time if not specified)

```
curl -X GET -H 'Content-type: application/json' -H 'Accept: application/json' -d '{"host" : "8.8.8.8", "timeframe_starts_at":"1612951108"}' 127.0.0.1:3000/ping_statistics

{"min":0.041,"max":0.044,"mean":0.043,"median":0.043,"standard_deviation":0.001,"loss_percentage":0.0}
```

If no ping was available over specified timeframe, will return 404:

```
curl -X GET -H 'Content-type: application/json' -H 'Accept: application/json' -d '{"host" : "8.8.8.8", "timeframe_starts_at":"1612951108", "timeframe_ends_at":"1612951118"}' 127.0.0.1:3000/ping_statistics

{"errors":{"base":"can't find any ping statistics over specified period"}}
```
