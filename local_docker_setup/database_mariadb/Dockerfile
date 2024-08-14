FROM mariadb:10.5.10

COPY ./source /tmp/source
COPY ./entrypoint.sh /usr/local/bin/custom_entrypoint.sh
RUN chmod +x /usr/local/bin/custom_entrypoint.sh
ENTRYPOINT ["/usr/local/bin/custom_entrypoint.sh"]

CMD ["mysqld"]
