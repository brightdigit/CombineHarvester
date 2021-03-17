**PROTOCOL**

# `CLLocationManagerCombineDelegate`

```swift
public protocol CLLocationManagerCombineDelegate: CLLocationManagerDelegate
```

## Properties
### `authorizationPublisher`

```swift
var authorizationPublisher: AnyPublisher<CLAuthorizationStatus, Never>
```

### `locationPublisher`

```swift
var locationPublisher: AnyPublisher<[CLLocation], Never>
```
