//
//  SwiftUIView.swift
//  
//
//  Created by Leo Dion on 3/2/21.
//

import SwiftUI

public struct CHView: View {
  public init() {
    
  }
    public var body: some View {
      TabView{
        LocationView().tabItem {
          VStack{
            Image(systemName: "location.fill")
            Text("Location")
          }
        }
      }.edgesIgnoringSafeArea(.all)
    }
}

struct CHView_Previews: PreviewProvider {
    static var previews: some View {
      CHView()
    }
}
