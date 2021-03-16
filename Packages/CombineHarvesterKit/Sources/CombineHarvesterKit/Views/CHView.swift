import SwiftUI

public struct CHView: View {
  public init() {}

  public var body: some View {
    TabView {
      LocationView().tabItem {
        VStack {
          Image(systemName: "location.fill")
          Text("Location")
        }
      }.tag(1)
      BaconView().tabItem {
        VStack {
          Image(systemName: "mouth")
          Text("Bacon")
        }
      }.tag(2)
    }.edgesIgnoringSafeArea(.all)
  }
}

struct CHView_Previews: PreviewProvider {
  static var previews: some View {
    CHView()
  }
}
