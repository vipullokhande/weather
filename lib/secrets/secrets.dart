var ak =
    'https:/api.openweathermap.org/data/2.5/forecast?id=1275339&appid={API_KEY}';
String apiUrl(String city) =>
    'https://api.openweathermap.org/data/2.5/weather?q=$city&appid={API_KEY}';
