**CLASS**

# `CLLocationManagerPublicist`

```swift
public class CLLocationManagerPublicist: NSObject, CLLocationManagerCombineDelegate
```

## Methods
### `authorizationPublisher()`

```swift
public func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never>
```

### `locationPublisher()`

```swift
public func locationPublisher() -> AnyPublisher<[CLLocation], Never>
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
