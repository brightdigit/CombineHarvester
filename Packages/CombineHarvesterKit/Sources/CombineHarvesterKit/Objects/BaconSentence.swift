import Foundation

public struct BaconSentence: Identifiable {
  public init(sentence: String) {
    date = Date()
    self.sentence = sentence
  }

  public let date: Date
  public let sentence: String

  public var id: Date {
    return date
  }
}
