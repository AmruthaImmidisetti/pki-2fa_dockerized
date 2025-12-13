# Stage 1: builder
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && pip wheel --no-deps --wheel-dir /wheels -r requirements.txt

# Stage 2: runtime
FROM python:3.11-slim
ENV TZ=UTC
WORKDIR /app

# system deps (cron)
RUN apt-get update && apt-get install -y cron tzdata && \
    ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# copy wheels & install
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/*.whl

# copy app code and keys
COPY app /app
COPY student_private.pem /app/student_private.pem
COPY student_public.pem /app/student_public.pem
COPY instructor_public.pem /app/instructor_public.pem
COPY cron/2fa-cron /etc/cron.d/2fa-cron

# permissions & volumes
RUN chmod 0644 /etc/cron.d/2fa-cron && crontab /etc/cron.d/2fa-cron
RUN mkdir -p /data /cron && chmod 755 /data /cron

EXPOSE 8080
CMD service cron start && uvicorn main:app --host 0.0.0.0 --port 8080
