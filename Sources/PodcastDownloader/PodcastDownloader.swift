
import ArgumentParser
import Foundation
import PodcastKit
import Resourceful

struct PodcastDownloader: ParsableCommand {

    @Option(name: .long, help: "The podcast feed.")
    var feed: String

    @Option(name: .long, help: "The output directory.")
    var output: String

    func run() throws {

        guard let directory = Process().currentDirectoryURL else {
            struct NoCurrentDirectoryURL: Error {}
            throw NoCurrentDirectoryURL()
        }

        guard let url = URL(string: feed) else {
            struct FeedNotURL: Error {}
            throw FeedNotURL()
        }

        let session = URLSession.shared
        let base = directory.appendingPathComponent(output)
        let rss = try session.get(.rss(for: url))

        print("Downloading \(rss.channel.title)")

        for item in rss.channel.items {
            print("Downloading \(item.title)")
            let mediaURL = try session.download(item.media)
            let outputURL = base.appendingPathComponent(item.filename)
            print("Saving to \(outputURL)")
            try FileManager.default.moveItem(at: mediaURL, to: outputURL)
        }
    }
}

extension Item {

    var filename: String {

        var filename = ""

        if let episodeNumber = episodeNumber {
            filename.append("\(episodeNumber) - ")
        }

        filename.append(title)

        if let type = enclosure.type.split(separator: "/").last {
            filename.append(".\(type)")
        }

        return filename
    }
}
