import SwiftSoup 
import SwiftUI

class DataServiceMXTrack: ObservableObject {
    var tracks = [MXTrack]() 
    let url = URL(string: "https://mxtrackguide.com/motocross-tracks-california")
    
    func fetchTracks() {
        do {
            if let url = url {
                let stringURL = try String(contentsOf: url) 
                let parsedURL = try SwiftSoup.parse(stringURL) 
                let title = try parsedURL.getElementsByClass("entry-title").eachText() 
                let trackDetails = try parsedURL.getElementsByClass("track-info-cat").eachText()
               
                var trackPosition = 0
                var trackLocations = [String]()
                for _ in trackDetails {
                    let trackSplit = trackDetails[trackPosition].components(separatedBy: "Location:") 
                    trackPosition += 1
                    trackLocations.append(trackSplit[1]) 
                }
                
                var locationPosition = 0 
                for i in title {
                    tracks.append(MXTrack(track: i, trackInfo: trackLocations[locationPosition].trimmingCharacters(in: .whitespaces)))
                    locationPosition += 1
                }
            }
        } catch {
            print("An error has occured in DataServiceMXTrack, fetchTracks: \(error)")
        }
    }
}
