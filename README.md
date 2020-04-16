# PodcastDownloader

Command line utility for downloading podcasts.

## Usage

For example, if you wanted to download all the episodes of Kermode and Mayo's Film Review podcast, you could do so like this:

``` shell
swift build
mkdir output-directory
.build/debug/PodcastDownloader \
    --feed https://podcasts.files.bbci.co.uk/b00lvdrj.rss \
    --output output-directory
```

