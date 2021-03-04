import Foundation
import Combine

public class BaconObject: ObservableObject {
  @Published var value : Int
  @Published var words = [BaconSentence]()
  
  @Published var requestSize : Int = 1
  @Published var maxSize : Int = 10
  @Published var seconds : TimeInterval = 1
  
  static let baseURL = URLComponents(string: "https://baconipsum.com/api/?type=all-meat&format=json")!
  
  public init (timerInterval: TimeInterval = 1.0) {
    self.value = 0
    
    let urlSession = URLSession.shared
    
    let urlPublisher =  $requestSize.map { (size) -> URL in
      var newURL = Self.baseURL
      newURL.queryItems?.append(URLQueryItem(name: "paras", value: size.description))
      return newURL.url!
    }.flatMap(urlSession.dataTaskPublisher(for:))
    .map(\.data)
    .decode(type: [String].self, decoder: JSONDecoder())
    .replaceError(with: [String]())
    .flatMap{$0.publisher}
    .map{ (paragraph) -> String in
      if let startIndex = paragraph.firstIndex(of: ".") {
        return .init(paragraph[paragraph.startIndex...startIndex])
      }
      return paragraph
    }
    .map(BaconSentence.init(sentence:))
    
    let timerPublisher =  self.$seconds.map{ (seconds) in
      Timer.publish(every: seconds, on: .current, in: .default).autoconnect()
    }.switchToLatest()
    
    let wordsPublisher = timerPublisher.map{_ in urlPublisher}.switchToLatest().combineLatest(self.$maxSize, { (newWord, maxSize) -> [BaconSentence] in
      var words = self.words
      words.insert(newWord, at: 0)
      if words.count > self.maxSize {
        let range = (self.maxSize-1...words.count-1)
        words.removeSubrange(range)
      }
      return words
    })
    
    wordsPublisher.receive(on: DispatchQueue.main).assign(to: &self.$words)
  }
}
