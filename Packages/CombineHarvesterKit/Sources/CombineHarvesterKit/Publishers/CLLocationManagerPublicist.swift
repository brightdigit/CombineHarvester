import Combine
import CoreLocation
import SwiftUI

public protocol CLLocationManagerCombineDelegate: CLLocationManagerDelegate {
  func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never>
  func locationPublisher() -> AnyPublisher<[CLLocation], Never>
  // func headingPublisher() -> AnyPublisher<CLHeading?, Never>
  // func errorPublisher() -> AnyPublisher<Error?, Never>
}

public class CLLocationManagerPublicist: NSObject, CLLocationManagerCombineDelegate {
  let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()

  let locationSubject = PassthroughSubject<[CLLocation], Never>()

  public func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
    return Just(CLLocationManager.authorizationStatus())
      .merge(with:
        authorizationSubject
      ).eraseToAnyPublisher()
  }

  public func locationPublisher() -> AnyPublisher<[CLLocation], Never> {
    return locationSubject.eraseToAnyPublisher()
  }

  public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationSubject.send(locations)
  }

  public func locationManager(_: CLLocationManager, didFailWithError _: Error) {
    // Implement to avoid crashes
    // Extra Credit: Create a publisher for errors :/
  }

  public func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    authorizationSubject.send(status)
  }
}
