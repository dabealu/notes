log in json (works starting from nginx 1.11.8)
```
log_format json escape=json '{ "timestamp": "$time_iso8601", '
'"host": "$host", '
'"remote_addr": "$remote_addr", '
'"remote_user": "$remote_user", '
'"body_bytes_sent": "$body_bytes_sent", '
'"request_time": "$request_time", '
'"status": "$status", '
'"request": "$request", '
'"request_method": "$request_method", '
'"http_referrer": "$http_referer", '
'"http_user_agent": "$http_user_agent" }';
```

request to http://localhost/myloc/?date=2010-10-10 rewrited to access file `date=2010-10-10`
```
location /myloc {
  rewrite /myloc/$ /myloc/date=$arg_date? break;
}
```
