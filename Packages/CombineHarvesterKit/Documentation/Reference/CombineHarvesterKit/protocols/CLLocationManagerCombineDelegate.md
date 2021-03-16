**PROTOCOL**

# `CLLocationManagerCombineDelegate`

```swift
public protocol CLLocationManagerCombineDelegate: CLLocationManagerDelegate
```

## Methods
### `authorizationPublisher()`

```swift
func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never>
```

### `locationPublisher()`

```swift
func locationPublisher() -> AnyPublisher<[CLLocation], Never>
```
