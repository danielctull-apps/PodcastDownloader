
public struct Item {
    public let episodeNumber: Int?
    public let title: String
    public let enclosure: Enclosure
}

extension Item: Codable {

    enum CodingKeys: String, CodingKey {
          case episodeNumber = "itunes:episode"
          case title
          case enclosure
      }
}
