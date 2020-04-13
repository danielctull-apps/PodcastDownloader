
import Foundation
import XMLCoder

public struct RSS: Codable {
    public let channel: Channel
}

extension RSS {

    public init(data: Data) throws {
        let coder = XMLDecoder(trimValueWhitespaces: true)
        self = try coder.decode(Self.self, from: data)
    }
}
