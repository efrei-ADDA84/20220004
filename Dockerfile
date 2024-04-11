FROM python:3.9-alpine
WORKDIR /app
COPY weather_wrapper.py .
RUN pip install --no-cache-dir requests==2.26.0 flask==2.0.1 werkzeug==2.1.0
EXPOSE 8080
CMD ["python", "weather_wrapper.py"]
