# Migration

Auto

# HTTPS

```
dokku letsencrypt:auto-renew askalfred-app
dokku letsencrypt:cron-job --add askalfred-app
dokku letsencrypt:auto-renew askalfred-api
dokku letsencrypt:cron-job --add askalfred-api
```

# Postico

```
dokku postgres:info postgresql # credentials
dokku postgres:expose # can access it from now on (and show PORT)
```

Use `api.askalfred.to` as host in Postico
