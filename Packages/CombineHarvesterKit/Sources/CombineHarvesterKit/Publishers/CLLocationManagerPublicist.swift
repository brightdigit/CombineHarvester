import Combine
import CoreLocation
import SwiftUI

public class CLLocationManagerPublicist: NSObject, CLLocationManagerCombineDelegate {
  let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()

  let locationSubject = PassthroughSubject<[CLLocation], Never>()

  public let authorizationPublisher: AnyPublisher<CLAuthorizationStatus, Never>

  public let locationPublisher: AnyPublisher<[CLLocation], Never>

  override public init() {
    authorizationPublisher = Just(.notDetermined)
      .merge(with:
        authorizationSubject
      ).eraseToAnyPublisher()

    locationPublisher = locationSubject.eraseToAnyPublisher()
    super.init()
  }

  public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationSubject.send(locations)
  }

  public func locationManager(_: CLLocationManager, didFailWithError _: Error) {
    // Implement to avoid crashes
    // Extra Credit: Create a publisher for errors :/
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationSubject.send(manager.authorizationStatus)
  }
}
