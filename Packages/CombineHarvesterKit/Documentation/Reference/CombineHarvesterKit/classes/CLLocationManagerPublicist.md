**CLASS**

# `CLLocationManagerPublicist`

```swift
public class CLLocationManagerPublicist: NSObject, CLLocationManagerCombineDelegate
```

## Properties
### `authorizationPublisher`

```swift
public let authorizationPublisher: AnyPublisher<CLAuthorizationStatus, Never>
```

### `locationPublisher`

```swift
public let locationPublisher: AnyPublisher<[CLLocation], Never>
```

## Methods
### `init()`

```swift
override public init()
```

### `locationManager(_:didUpdateLocations:)`

```swift
public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation])
```

### `locationManager(_:didFailWithError:)`

```swift
public func locationManager(_: CLLocationManager, didFailWithError _: Error)
```

### `locationManagerDidChangeAuthorization(_:)`

```swift
public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
```
