# Example to download data from website with help of API keys
#sign up and generate key from desired website
#this website gives data in JSON format, we are converting it to csv in this file itself
#further we can load this to SF tables or GCS location
#this is simple python program and needs python installation to execute this program


import requests
import pandas as pd

# Step 1: Define API details
API_KEY = "77d###9385###########"  # Replace with your WeatherAPI key # key hashed for security purpose
BASE_URL = "https://api.weatherapi.com/v1/current.json"

# Step 2: Define parameters
params = {
    "key": API_KEY,
    "q": "08817",  # city name, can also use lat,long like "41.8781,-87.6298"
    "aqi": "no"      # exclude air quality info for simplicity
}

# Step 3: Make the API call
response = requests.get(BASE_URL, params=params)

# Step 4: Check if response is successful
if response.status_code == 200:
    data = response.json()

    # Step 5: Flatten JSON into a DataFrame
    df = pd.json_normalize({
        "location": data["location"]["name"],
        "region": data["location"]["region"],
        "country": data["location"]["country"],
        "local_time": data["location"]["localtime"],
        "temperature_c": data["current"]["temp_c"],
        "condition": data["current"]["condition"]["text"],
        "humidity": data["current"]["humidity"],
        "wind_kph": data["current"]["wind_kph"]
    }, sep='_')

    # Step 6: Save as CSV
    df.to_csv("weather_api_csv_download/downloadcurrent_weather_edison_nj.csv", index=False)  # saving it to my local machine folder
    print("✅ Weather data saved to 'current_weather_edison_nj.csv'")
    print(df)

else:
    print(f"❌ Error: {response.status_code} - {response.text}")
