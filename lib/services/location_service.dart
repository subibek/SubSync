import 'package:geolocator/geolocator.dart';


class LocationService {

  final double siteLatitude;
  final double siteLongitude;
  final double allowRadiusMeters;

  LocationService({
    required this.siteLatitude,
    required this.siteLongitude,
    required this.allowRadiusMeters
  });

  Future<bool> ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.deniedForever){
      return false;
    }
    if(!await Geolocator.isLocationServiceEnabled()){
      return false;
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<String> canClockIn() async {
    final hasPermission = await ensurePermission();
    if(!hasPermission){
      return "Denied. No location service.";
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
    );

    if(position.isMocked){return "Denied. mock location detected.";}

    final distance = Geolocator.distanceBetween(
      position.latitude, position.longitude,
      siteLatitude,
      siteLongitude
    );

    print("${position.latitude}, ${position.longitude}");

    if(distance <= allowRadiusMeters) {
      return "Allowed";
    } else {
      return "Denied: you are ${distance.toStringAsFixed(0)}m from site.";
    }
  }

}
