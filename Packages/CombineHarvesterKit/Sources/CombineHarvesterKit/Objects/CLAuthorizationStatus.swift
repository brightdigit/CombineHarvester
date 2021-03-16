import CoreLocation

extension CLAuthorizationStatus {
  var isAuthorized: Bool {
    #if os(macOS)
      return self == .authorizedAlways
    #else
      return self == .authorizedAlways || self == .authorizedWhenInUse
    #endif
  }
}
