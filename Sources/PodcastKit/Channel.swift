
import Foundation

public struct Channel {
    public let title: String
    public let link: URL
    public let description: String
    public let items: [Item]
}


extension Channel: Codable {

    enum CodingKeys: String, CodingKey {
        case title
        case link
        case description
        case items = "item"
    }
}
