import Combine
import CoreLocation
import SwiftUI


class TrackablePublisher<Value> : Publisher {
  internal init(value: Value) {
    self.subject = CurrentValueSubject(value)
  }
  
  func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Value == S.Input {
    
  }
  

  
  typealias Output = Value
  
  typealias Failure = Never
  
  let subject : CurrentValueSubject<Value,Never>
}

@propertyWrapper
struct TrackablePublished<Value> {
  internal init(wrappedValue: Value) {
    self.publisher = .init(value: wrappedValue)
  }
  
  let publisher : TrackablePublisher<Value>
  var wrappedValue : Value {
    set {
      publisher.subject.send(newValue)
    }
    get {
      publisher.subject.value
    }
  }
  
}

public class CoreLocationObject: ObservableObject {
  //@TrackablePublished var authorizationStatus = CLAuthorizationStatus.notDetermined
  @TrackablePublished var lastLocation: CLLocation?
  @TrackablePublished var lastError: Error?

  public let manager: CLLocationManager
  public let publicist: CLLocationManagerCombineDelegate

  public var cancellables = [AnyCancellable]()

  public init() {
    let manager = CLLocationManager()
    let publicist = CLLocationManagerPublicist()

    manager.delegate = publicist

    
    self.manager = manager
    self.publicist = publicist

    // trigger an update when authorization changes
//    publicist.authorizationPublisher
//      .filter { $0.isAuthorized }
//      .map { _ in () }
      //.sink(receiveValue: beginUpdates)
      //.store(in: &cancellables)

    // set authorization status when authorization changes
    publicist.errorPublisher.map{ $0 as Error? }
    .assign(to: \.lastError, on: self).store(in: &self.cancellables)
//    publicist.authorizationPublisher
//      // since this is used in the UI,
//      //  it needs to be on the main DispatchQueue
//      .receive(on: DispatchQueue.main)
//      // store the value in the authorizationStatus property
//      .assign(to: \.authorizationStatus, on: self)
//      .store(in: &self.cancellables)

    publicist.locationPublisher
      // convert the array of CLLocation into a Publisher itself
      .flatMap(Publishers.Sequence.init(sequence:))
      // in order to match the property map to Optional
      .map { $0 as CLLocation? }
      // since this is used in the UI,
      //  it needs to be on the main DispatchQueue
     // .receive(on: DispatchQueue.main)
      // store the value in the location property
      .assign(to: \.lastLocation, on: self)
      .store(in: &self.cancellables)
  }

//  func authorize() {
//    if manager.authorizationStatus == .notDetermined {
//      manager.requestWhenInUseAuthorization()
//    }
//  }


}
