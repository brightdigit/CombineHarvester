//
//  SwiftUIView.swift
//  
//
//  Created by Leo Dion on 3/4/21.
//

import SwiftUI
import Combine

struct BaconView: View {
  let dateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .long
    return formatter
  }()
  
  @EnvironmentObject var object : BaconObject
  
  var body: some View {
    VStack{
      Form{
        Section{
          HStack{
            Text("Update every")
            Text(object.seconds.description)
            Stepper("seconds", value: $object.seconds, in: 0.5...10, step: 0.25)
          }
          HStack{
            Text("Keep upto")
            Text(object.maxSize.description)
            Stepper("items", value: $object.maxSize, in: 1...20, step: 1)
          }
          HStack{
            Text("Request upto")
            Text(object.requestSize.description)
            Stepper("items", value: $object.requestSize, in: 1...20, step: 1)
          }
        }
      }
      .frame(height: 200.0)
      List(object.words) { (item) in
        VStack(alignment: .leading) {
          Text(item.sentence)
          Text(self.dateFormatter.string(from: item.date)).font(.caption).opacity(0.75)
        }
      
      }.animation(.easeIn)
    }
  }
}

struct BaconView_Previews: PreviewProvider {
  static var previews: some View {
    BaconView().environmentObject(BaconObject()).previewDevice("iPhone 8")
  }
}
