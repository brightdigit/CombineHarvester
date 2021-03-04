//
//  SwiftUIView.swift
//  
//
//  Created by Leo Dion on 3/4/21.
//

import SwiftUI
import Combine

public struct BaconSentence : Identifiable {
  public init(sentence: String) {
    self.date = Date()
    self.sentence = sentence
  }
  
  public let date : Date
  public let sentence: String
  
  public var id: Date {
    return self.date
  }
}

public class BaconObject: ObservableObject {
  @Published var value : Int
  @Published var words = [BaconSentence]()
  
  @Published var requestSize : Int = 1
  @Published var maxSize : Int = 10
  @Published var seconds : TimeInterval = 1
  
  var cancellable : AnyCancellable!
  var timerCancellable : Cancellable!
  
  static let baseURL = URLComponents(string: "https://baconipsum.com/api/?type=all-meat&format=json")!
  
  public init (timerInterval: TimeInterval = 1.0) {
    self.value = 0
    
    let urlSession = URLSession.shared
    
    let urlPublisher =  $requestSize.compactMap { (size) -> URL? in
      var newURL = Self.baseURL
      newURL.queryItems?.append(URLQueryItem(name: "sentences", value: size.description))
      return newURL.url
    }.flatMap(urlSession.dataTaskPublisher(for:)).map(\.data)
    .decode(type: [String].self, decoder: JSONDecoder())
    .replaceError(with: [String]())
    .flatMap{$0.publisher}
    .map(BaconSentence.init(sentence:))
    
    let timerPublisher =  self.$seconds.flatMap{ (seconds) -> Timer.TimerPublisher in
      if let cancellable = self.timerCancellable {
        cancellable.cancel()
      }
      let publisher = Timer.publish(every: seconds, on: .current, in: .default)
      self.timerCancellable = publisher.connect()
      return publisher
    }
    
    let wordsPublisher = timerPublisher.flatMap{_ in urlPublisher}.combineLatest(self.$maxSize, { (newWord, maxSize) -> [BaconSentence] in
      var words = self.words
      words.insert(newWord, at: 0)
      if words.count > self.maxSize {
        let range = (self.maxSize-1...words.count-1)
        words.removeSubrange(range)
      }
      return words
    })
    
    wordsPublisher.receive(on: DispatchQueue.main).print().assign(to: &self.$words)
    
    
  }
}

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
      VStack{
        List(object.words) { (item) in
          VStack(alignment: .leading) {
            Text(item.sentence)
            Text(self.dateFormatter.string(from: item.date)).font(.caption).opacity(0.75)
          }
        }.animation(.easeIn)
      }
    }
  }
}

struct BaconView_Previews: PreviewProvider {
  static var previews: some View {
    BaconView().environmentObject(BaconObject())
  }
}
