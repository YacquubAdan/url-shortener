FROM python:3.12-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=/out -r requirements.txt
COPY src/ ./src
COPY static/ ./static

FROM python:3.12-slim

WORKDIR /app
COPY --from=build /out /usr/local
COPY --from=build /app/src /app/src
COPY --from=build /app/static /app/static
ENV PYTHONPATH=/app 
USER 65532:65532
EXPOSE 8080

CMD ["python", "-m", "uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8080"]
