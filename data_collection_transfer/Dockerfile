FROM ubuntu:22.04

RUN apt-get update -y && apt-get install curl cron -y

COPY ./scripts/collect_metric.sh /tmp/

RUN chmod 550 /tmp/collect_metric.sh

RUN echo "* * * * * /tmp/collect_metric.sh" > /etc/cron.d/mon-cron

RUN chmod 644 /etc/cron.d/mon-cron

RUN crontab /etc/cron.d/mon-cron

RUN touch /var/log/cron.log

CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]
