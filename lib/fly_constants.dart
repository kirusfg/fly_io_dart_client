enum FlyRegion {
  ams('ams', 'Amsterdam, Netherlands', 52.37403, 4.88969, 'Netherlands'),
  arn('arn', 'Stockholm, Sweden', 59.3293, 18.0686, 'Sweden'),
  atl('atl', 'Atlanta, Georgia (US)', 33.7490, -84.3880, 'US'),
  bog('bog', 'Bogotá, Colombia', 4.7110, -74.0721, 'Colombia'),
  bom('bom', 'Mumbai, India', 19.0760, 72.8777, 'India'),
  bos('bos', 'Boston, Massachusetts (US)', 42.3601, -71.0589, 'US'),
  cdg('cdg', 'Paris, France', 48.8566, 2.3522, 'France'),
  den('den', 'Denver, Colorado (US)', 39.7392, -104.9903, 'US'),
  dfw('dfw', 'Dallas, Texas (US)', 32.7767, -96.7970, 'US'),
  ewr('ewr', 'Secaucus, NJ (US)', 40.7895, -74.0565, 'US'),
  eze('eze', 'Ezeiza, Argentina', -34.8222, -58.5369, 'Argentina'),
  fra('fra', 'Frankfurt, Germany', 50.1109, 8.6821, 'Germany'),
  gdl('gdl', 'Guadalajara, Mexico', 20.6597, -103.3496, 'Mexico'),
  gig('gig', 'Rio de Janeiro, Brazil', -22.9068, -43.1729, 'Brazil'),
  gru('gru', 'Sao Paulo, Brazil', -23.5505, -46.6333, 'Brazil'),
  hkg('hkg', 'Hong Kong, Hong Kong', 22.3193, 114.1694, 'Hong Kong'),
  iad('iad', 'Ashburn, Virginia (US)', 39.0438, -77.4874, 'US'),
  jnb('jnb', 'Johannesburg, South Africa', -26.2041, 28.0473, 'South Africa'),
  lax('lax', 'Los Angeles, California (US)', 34.0522, -118.2437, 'US'),
  lhr('lhr', 'London, United Kingdom', 51.5074, -0.1278, 'United Kingdom'),
  maa('maa', 'Chennai (Madras), India', 13.0827, 80.2707, 'India'),
  mad('mad', 'Madrid, Spain', 40.4168, -3.7038, 'Spain'),
  mia('mia', 'Miami, Florida (US)', 25.7617, -80.1918, 'US'),
  nrt('nrt', 'Tokyo, Japan', 35.6895, 139.6917, 'Japan'),
  ord('ord', 'Chicago, Illinois (US)', 41.8781, -87.6298, 'US'),
  otp('otp', 'Bucharest, Romania', 44.4268, 26.1025, 'Romania'),
  phx('phx', 'Phoenix, Arizona (US)', 33.4484, -112.0740, 'US'),
  qro('qro', 'Querétaro, Mexico', 20.5888, -100.3899, 'Mexico'),
  scl('scl', 'Santiago, Chile', -33.4489, -70.6693, 'Chile'),
  sea('sea', 'Seattle, Washington (US)', 47.6062, -122.3321, 'US'),
  sin('sin', 'Singapore, Singapore', 1.3521, 103.8198, 'Singapore'),
  sjc('sjc', 'San Jose, California (US)', 37.3382, -121.8863, 'US'),
  syd('syd', 'Sydney, Australia', -33.8688, 151.2093, 'Australia'),
  waw('waw', 'Warsaw, Poland', 52.2297, 21.0122, 'Poland'),
  yul('yul', 'Montreal, Canada', 45.5017, -73.5673, 'Canada'),
  yyz('yyz', 'Toronto, Canada', 43.6532, -79.3832, 'Canada'),
  ;

  final String code;
  final String name;
  final double lat;
  final double lon;
  final String country;

  const FlyRegion(this.code, this.name, this.lat, this.lon, this.country);

  @override
  String toString() {
    return code;
  }

  static FlyRegion fromCode(String code, {FlyRegion defaultRegion = FlyRegion.sin}) {
    return values.firstWhere((region) => region.code == code, orElse: () => defaultRegion);
  }
}
