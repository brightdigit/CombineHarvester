import Combine
import CoreLocation
import SwiftUI

enum Direction: Int, CustomStringConvertible {
  static let halfStep = 11.25
  static let maxDegrees = 360.0
  init<Floating: BinaryFloatingPoint>(degrees: Floating) {
    let halfStep = Floating(Self.halfStep)
    let maxDegrees = Floating(Self.maxDegrees)
    let valueOffset = (degrees + halfStep).truncatingRemainder(dividingBy: maxDegrees)
    let index = Int(valueOffset / halfStep / 2.0)
    self.init(rawValue: index)!
  }

  var description: String {
    return Self.descriptions[rawValue]
  }

  case north = 0
  case northByNorthEast = 1
  case northEast = 2
  case eastByNorthEast = 3
  case east = 4
  case eastBySouthEast = 5
  case southEast = 6
  case southBySouthEast = 7
  case south = 8
  case southBySouthWest = 9
  case southWest = 10
  case westBySouthWest = 11
  case west = 12
  case westByNorthWest = 13
  case northWest = 14
  case northByNorthWest = 15

  static let descriptions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
}

extension CLAuthorizationStatus: CustomStringConvertible {
  public var description: String {
    switch self {
    case .authorizedAlways:
      return "Always"
    case .authorizedWhenInUse:
      return "When In Use"
    case .denied:
      return "Denied"
    case .notDetermined:
      return "Not Determined"
    case .restricted:
      return "Restricted"
    @unknown default:
      return "🤷‍♂️"
    }
  }
}

public struct LocationView: View {
  // CLLocationManager is basically a singleton so an EnvironmentObject ObservableObject makes sense
  @EnvironmentObject var locationObject: CoreLocationObject

  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()

  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    return formatter
  }()

  public init() {}

  public var body: some View {
    EmptyView()
//    VStack {
//      // use our extension method to display a description of the status
//      self.viewForAuthorizationStatus(self.locationObject.authorizationStatus)
//
//      // use Optional.map to hide the Text if there's no location
//      self.locationObject.location.map(
//        self.viewForLocation(_:)
//      )
//    }
  }

//  @ViewBuilder
//  func viewForAuthorizationStatus(_: CLAuthorizationStatus) -> some View {
//    if locationObject.authorizationStatus == .notDetermined {
//      Button(action: locationObject.authorize) {
//        HStack {
//          Image(systemName: "location.fill")
//          Text("Authorize")
//        }
//      }.padding(8).background(Color.blue).cornerRadius(10.0).foregroundColor(.white)
//    } else {
//      Text("\(locationObject.authorizationStatus.description)").font(.footnote).opacity(0.5)
//    }
//  }

  func description(fromValue value: Double) -> String! {
    numberFormatter.string(from: NSNumber(value: value))
  }

  func description(forCourse course: CLLocationDirection) -> String {
    Direction(degrees: course).description
  }

  func viewForLocation(_ location: CLLocation) -> some View {
    VStack {
      Text("\(self.description(fromValue: location.coordinate.latitude)), \(self.description(fromValue: location.coordinate.longitude))").bold()
      Text("\(self.description(fromValue: abs(location.altitude))) meters \(location.altitude.sign == FloatingPointSign.minus ? "below" : "above") sea level").font(.subheadline)
      Text("Traveling \(self.description(forCourse: location.course)) at \(self.description(fromValue: location.speed)) m/s").font(.subheadline)
      Text("Updated at \(self.dateFormatter.string(from: location.timestamp))").font(.footnote)
    }
  }
}

struct LocationView_Previews: PreviewProvider {
  static var previews: some View {
    LocationView().environmentObject(CoreLocationObject())
  }
}
