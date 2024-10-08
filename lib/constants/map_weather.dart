const List<String> cities = [
  'Hanoi',
  'London',
  'New York',
  'Tokyo',
  'Paris',
  'Berlin',
  'Rio de Janeiro',
  'Istanbul',
  'Seoul',
  'Los Angeles',
];

// Bản đồ mô tả âm nhạc dựa trên điều kiện thời tiết
const Map<String, Map<String, dynamic>> weatherDescriptions = {
  'clear sky': {
    'description': '🎶 Vui tươi, năng lượng cao, dễ nhảy múa.',
  },
  'few clouds': {
    'description': '🎶 Vui vẻ, nhưng có chút nhẹ nhàng.',
  },
  'scattered clouds': {
    'description': '🎶 Bình yên, thư giãn, đôi khi mang hơi hướng tươi sáng.',
  },
  'broken clouds': {
    'description': '🎶 Trầm lắng hơn, mang tính suy tư.',
  },
  'overcast clouds': {
    'description': '🎶 Ẩm ướt, trầm lắng, đôi khi buồn bã.',
  },
  'light intensity drizzle': {
    'description': '🎶 Nhẹ nhàng, dễ chịu, pha chút buồn.',
  },
  'drizzle': {
    'description': '🎶 Dịu dàng, thoải mái, nhưng có cảm giác lười biếng.',
  },
  'heavy intensity drizzle': {
    'description': '🎶 Đậm đà, mang tính cảm xúc mạnh.',
  },
  'light rain': {
    'description': '🎶 Nhẹ nhàng, dễ chịu, pha chút buồn.',
  },
  'moderate rain': {
    'description': '🎶 Chậm, u buồn, trầm mặc.',
  },
  'heavy intensity rain': {
    'description': '🎶 Mạnh mẽ, cảm xúc mãnh liệt, đôi khi sầu bi.',
  },
  'shower rain': {
    'description': '🎶 Cảm xúc, đôi chút sôi động nhưng ẩn chứa sự buồn bã.',
  },
  'thunderstorm': {
    'description': '🎶 Mạnh mẽ, kịch tính, năng lượng cao.',
  },
  'heavy thunderstorm': {
    'description': '🎶 Nhiệt huyết, căng thẳng, đầy cảm xúc.',
  },
  'ragged thunderstorm': {
    'description': '🎶 Kịch tính, đầy sức mạnh và cảm xúc mãnh liệt.',
  },
  'light snow': {
    'description': '🎶 Lãng mạn, nhẹ nhàng, cảm giác dịu dàng.',
  },
  'snow': {
    'description': '🎶 Lãng mạn, ấm áp, nhẹ nhàng.',
  },
  'heavy snow': {
    'description': '🎶 Mềm mại, thơ mộng, nhưng có cảm giác lạnh lẽo.',
  },
  'mist': {
    'description': '🎶 Bí ẩn, trầm lắng, dễ gây suy tư.',
  },
  'smoke': {
    'description': '🎶 Đen tối, ma mị, u ám.',
  },
  'haze': {
    'description': '🎶 Dịu dàng, ấm áp, dễ chịu.',
  },
  'dust': {
    'description': '🎶 Độc đáo, lạ thường, có chút hoài cổ.',
  },
  'sand': {
    'description': '🎶 Năng động, mạnh mẽ, pha chút nhiệt đới.',
  },
  'ash': {
    'description': '🎶 U ám, lặng lẽ, có chút lôi cuốn.',
  },
  'squall': {
    'description': '🎶 Kịch tính, mạnh mẽ, đầy năng lượng.',
  },
  'tornado': {
    'description': '🎶 Bão tố, mãnh liệt, đầy sức mạnh.',
  },
  'windy': {
    'description': '🎶 Thoải mái, thư giãn, nhẹ nhàng.',
  },
  'hurricane': {
    'description': '🎶 Mãnh liệt, mạnh mẽ, căng thẳng.',
  },
};
