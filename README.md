# Migration

Auto

# HTTPS

```
dokku letsencrypt:auto-renew askalfred-app
dokku letsencrypt:cron-job --add askalfred-app
dokku letsencrypt:auto-renew askalfred-api
dokku letsencrypt:cron-job --add askalfred-api
```
