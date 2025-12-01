FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libopenblas-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 1) 의존성 먼저
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# 2) 애플리케이션 코드
# 2) 보안을 위해 non-root 사용자 생성
RUN adduser --disabled-password --gecos "" appuser

# 3) 애플리케이션 코드 (권한 부여)
COPY --chown=appuser:appuser . .

ENV PYTHONPATH=/app
ENV PYTHONDONTWRITEBYTECODE=1

USER appuser

CMD ["uvicorn", "app.server:app", "--host", "0.0.0.0", "--port", "8000"]