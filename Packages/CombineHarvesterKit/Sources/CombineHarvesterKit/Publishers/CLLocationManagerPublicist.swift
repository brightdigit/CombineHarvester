import Combine
import CoreLocation
import SwiftUI

public class CLLocationManagerPublicist: NSObject, CLLocationManagerCombineDelegate {
  public let errorPublisher : AnyPublisher<Error, Never>
  
  let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()

  let locationSubject = PassthroughSubject<[CLLocation], Never>()
  
  let errorSubject = PassthroughSubject<Error, Never>()

  public let authorizationPublisher: AnyPublisher<CLAuthorizationStatus, Never>

  public let locationPublisher: AnyPublisher<[CLLocation], Never>

  override public init() {
    authorizationPublisher = Just(.notDetermined)
      .merge(with:
        authorizationSubject
      ).eraseToAnyPublisher()

    locationPublisher = locationSubject.eraseToAnyPublisher()
    errorPublisher = errorSubject.eraseToAnyPublisher()
    super.init()
  }

  public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationSubject.send(locations)
  }

  public func locationManager(_: CLLocationManager, didFailWithError error: Error) {
    errorSubject.send(error)
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationSubject.send(manager.authorizationStatus)
  }
}
