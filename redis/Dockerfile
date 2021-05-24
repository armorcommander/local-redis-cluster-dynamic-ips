FROM redis:6.2.3-alpine

RUN apk add gettext

COPY redis.conf /etc/redis/redis.conf.template
COPY start.sh /start.sh

CMD ["/bin/sh", "/start.sh"]
