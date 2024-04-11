from flask import Flask, request, jsonify
import os
import requests

app = Flask(__name__)

@app.route('/', methods=['GET'])
def get_weather():
    latitude = request.args.get('lat')
    longitude = request.args.get('lon')
    api_key = os.environ.get('API_KEY')
    
    if latitude is None or longitude is None:
        return jsonify({'error': 'Latitude and longitude parameters are required'}), 400
    
    url = f'http://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}&units=metric'
    
    response = requests.get(url)
    data = response.json()
    
    if response.status_code == 200:
        weather_description = data['weather'][0]['description']
        temperature = data['main']['temp']
        return jsonify({'weather': weather_description, 'temperature': temperature}), 200
    else:
        return jsonify({'error': 'Failed to fetch weather data'}), 500

if __name__ == "__main__":
    app.run(host='localhost', port=8081)
