
import Foundation
import Resourceful

extension Resource where Value == RSS {

    public static func rss(for feed: URL) -> Self {
        Resource(request: URLRequest(url: feed)) { try RSS(data: $0.data) }
    }
}

extension Item {

    public var media: Resource<Data> {
        Resource(request: URLRequest(url: enclosure.url)) { $0.data }
    }
}
