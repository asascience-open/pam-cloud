

#syntax=docker/dockerfile:1.7
FROM python:3.10-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV HOME=/home/pypam_dagster

# Output logging faster
ENV PYTHONUNBUFFERED=1
# Show deprecation warnings https://docs.djangoproject.com/en/2.2/howto/upgrade-version/#resolving-deprecation-warnings
ENV PYTHONWARNINGS=once



WORKDIR ${HOME}
COPY ./pyproject.toml  uv.lock  ${HOME}/

RUN uv sync --locked --no-dev --no-install-project



COPY ./src/dagster_pypam ${HOME}/

RUN uv sync --locked --no-dev



ENV PATH="${HOME}/.venv/bin:${PATH}"


EXPOSE 4000

HEALTHCHECK --timeout=1s --start-period=3s --interval=3s --retries=20 CMD ["dagster", "api", "grpc-health-check", "-p", "4000"]

CMD [ "dagster", "code-server", "start", "-p", "4000", "-f", "definitions.py", "-h", "0.0.0.0" ]

