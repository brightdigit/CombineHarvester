import Combine
import Foundation

public class BaconObject: ObservableObject {
  @Published var words = [BaconSentence]()

  @Published var requestSize: Int = 1
  @Published var maxSize: Int = 10
  @Published var seconds: TimeInterval = 1

  static let baseURL = URLComponents(string: "https://baconipsum.com/api/?type=all-meat&format=json")!

  static func url(basedOnSizeOf size: Int) -> URL {
    var newURL = baseURL
    newURL.queryItems?.append(URLQueryItem(name: "paras", value: size.description))
    return newURL.url!
  }

  public init(timerInterval: TimeInterval = 1.0) {
    seconds = timerInterval

    let urlSession = URLSession.shared

    let urlPublisher = $requestSize
      .map(Self.url(basedOnSizeOf:))
      .flatMap(urlSession.dataTaskPublisher(for:))
      .map(\.data)
      .decode(type: [String].self, decoder: JSONDecoder())
      .replaceError(with: [String]())
      .flatMap { $0.publisher }
      .map { (paragraph) -> String in
        if let startIndex = paragraph.firstIndex(of: ".") {
          return .init(paragraph[paragraph.startIndex ... startIndex])
        }
        return paragraph
      }
      .map(BaconSentence.init(sentence:))

    let timerPublisher = $seconds.map { seconds in
      Timer.publish(every: seconds, on: .current, in: .default).autoconnect()
    }.switchToLatest()

    let wordsPublisher = timerPublisher.map { _ in urlPublisher }.switchToLatest().combineLatest($maxSize) { (newWord, _) -> [BaconSentence] in
      var words = self.words
      words.insert(newWord, at: 0)
      if words.count > self.maxSize {
        let range = (self.maxSize - 1 ... words.count - 1)
        words.removeSubrange(range)
      }
      return words
    }

    wordsPublisher.receive(on: DispatchQueue.main).assign(to: &$words)
  }
}
