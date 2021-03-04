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
    self.id = Date()
    self.sentence = sentence
  }
  
  public let id : Date
  public let sentence: String
}

public class BaconObject: ObservableObject {
  @Published var value : Int
  @Published var words = [BaconSentence]()
  
  let maxSize : Int = 10
  
  var increment = PassthroughSubject<Void, Never>()
  
  var cancellable : AnyCancellable!
  
  static let url = URL(string: "https://baconipsum.com/api/?type=all-meat&sentences=1&format=json")!
  
  public init (timerInterval: TimeInterval = 1.0) {
    self.value = 0
    
    let urlSession = URLSession.shared
    
    let urlPublisher = urlSession.dataTaskPublisher(for: Self.url)
      .map(\.data)
      .decode(type: [String].self, decoder: JSONDecoder())
      .replaceError(with: [String]())
      .flatMap{$0.publisher}
      .map(BaconSentence.init(sentence:))
    
    let wordsPublisher = Timer.publish(every: timerInterval, on: .current, in: .default)
      .autoconnect()
      .flatMap {_ in urlPublisher }
      .map({ (newWord) -> [BaconSentence] in
        var words = self.words
        if words.count > self.maxSize {
          let range = (self.maxSize...words.count-1)
          words.removeSubrange(range)
        }
        words.insert(newWord, at: 0)
        return words
      })
      
    wordsPublisher.receive(on: DispatchQueue.main).print().assign(to: &self.$words)
    
    cancellable = increment.receive(on: DispatchQueue.main).sink{
        self.value += 1
    }
  }
}

struct BaconView: View {
  @EnvironmentObject var object : BaconObject
  
    var body: some View {
      VStack{
        List(object.words) {
          Text($0.sentence)
        }.animation(.easeIn)
      }
    }
}

struct BaconView_Previews: PreviewProvider {
    static var previews: some View {
      BaconView().environmentObject(BaconObject())
    }
}
