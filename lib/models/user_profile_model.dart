class UserProfileModel {
  final String userId;
  final String fullName;
  final String email;
  final bool admin;
  final UserLocation location;

  UserProfileModel(
      {required this.userId,
      required this.email,
      required this.fullName,
      required this.admin,
      required this.location});

  static UserProfileModel fromJson(Map<String, dynamic> json, String userId) {
    final UserLocation location = UserLocation.fromJson(json['location']);
    return UserProfileModel(
      userId: userId,
      email: json['email'],
      fullName: json['fullname'],
      admin: json['admin'] ?? false,
      location: location,
    );
  }

  UserProfileModel copyWith(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: userId,
      email: email,
      location: json['location'] ?? location,
      fullName: json['fullname'] ?? fullName,
      admin: admin,
    );
  }
}

class UserLocation {
  final String locationName;
  final Coordinates coordinates;

  UserLocation({required this.coordinates, required this.locationName});

  static UserLocation fromJson(Map<String, dynamic> json) {
    final Coordinates coordinates = Coordinates.fromJson(json['coords']);
    return UserLocation(coordinates: coordinates, locationName: json['name']);
  }
}

class Coordinates {
  final double lat;
  final double long;

  Coordinates({required this.lat, required this.long});

  static Coordinates fromJson(Map<String, dynamic> json) {
    return Coordinates(lat: json['lat'], long: json['lng']);
  }
}
