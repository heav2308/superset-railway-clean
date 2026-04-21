FROM apache/superset:latest

USER root

RUN bash -lc "source /app/.venv/bin/activate && pip install --no-cache-dir psycopg2-binary"

COPY start.sh /app/start.sh
COPY superset_config.py /app/superset_config.py

RUN chmod +x /app/start.sh && chown superset:superset /app/start.sh /app/superset_config.py

USER superset

ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

CMD ["/app/start.sh"]
