FROM python:3.9-alpine
WORKDIR /app
COPY weather_wrapper.py .
RUN pip install --no-cache-dir requests==2.26.0
RUN pip install --no-cache-dir flask==2.0.1
CMD ["python", "weather_wrapper.py"]
