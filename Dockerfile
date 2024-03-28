
FROM python:3.9-slim
WORKDIR /app
COPY weather_wrapper.py .
RUN pip install requests
CMD ["python", "weather_wrapper.py"]
