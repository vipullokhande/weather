var ak =
    'https:/api.openweathermap.org/data/2.5/forecast?id=1275339&appid=07fa88dbf4794d7273b2b60406b58e06';
String apiUrl(String city) =>
    'https://api.openweathermap.org/data/2.5/weather?q=$city&appid={API_KEY}';
