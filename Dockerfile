FROM apache/superset:latest

COPY start.sh /app/start.sh
COPY superset_config.py /app/superset_config.py

RUN chmod +x /app/start.sh && chown superset:superset /app/start.sh /app/superset_config.py

USER superset

ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

CMD ["/app/start.sh"]
