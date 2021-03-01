import Combine
import CoreLocation
import SwiftUI

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

  public init () {}
  
  public var body: some View {
    VStack {
      // use our extension method to display a description of the status
      self.viewForAuthorizationStatus(self.locationObject.authorizationStatus)
      
      // use Optional.map to hide the Text if there's no location
      self.locationObject.location.map (
        self.viewForLocation(_:)
      )
    }
  }
  
  @ViewBuilder
  func viewForAuthorizationStatus(_ authorizationStatus: CLAuthorizationStatus) -> some View {
      if locationObject.authorizationStatus == .notDetermined {
        Button(action: self.locationObject.authorize) {
          HStack{
            Image(systemName: "location.fill")
            Text("Authorize")
          }
        }.padding(8).background(Color.blue).cornerRadius(10.0).foregroundColor(.white)
      } else {
        Text("\(locationObject.authorizationStatus.description)").font(.footnote).opacity(0.5)
      }
    
  }
  
  func viewForLocation(_ location: CLLocation) -> some View {
    VStack{
      Text("\(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
//    location.altitude
//    location.coordinate
//    location.course
//    location.speed
//    location.timestamp
  }
}

struct LocationView_Previews: PreviewProvider {
  static var previews: some View {
    LocationView().environmentObject(CoreLocationObject())
  }
}
