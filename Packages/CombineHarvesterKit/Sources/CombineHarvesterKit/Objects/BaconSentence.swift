
import Foundation

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
