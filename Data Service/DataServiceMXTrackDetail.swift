import SwiftSoup 
import SwiftUI

class DataServiceMXTrackDetail: ObservableObject {
    let url = URL(string: "https://mxtrackguide.com/motocross-tracks-california")
    var urls = [String]()
    var trackInfo = [MXTrackDetail]()
    
    func fetchURLs() {
        do {
            if let url = url {
                let stringURL = try String(contentsOf: url) 
                let document = try SwiftSoup.parse(stringURL) 
                let detailURLs = try document.getElementsByClass("view-entry-button")
                
                for detail in detailURLs.array() {
                    do {
                       try urls.append(detail.attr("href"))
                    } catch {
                        print("An error has occured in DataServiceMXTrackDetail, fetchURLs, for details in detailURLs: \(error)")
                    }
                }
            }
        } catch {
            print("An error has occured in DataServiceMXTrackDetail, fetchURls: \(error)")
        }
    }
    
    func fetchDetails() {
        for url in urls {
            let detailURL = URL(string: url) 
            if let detailURL = detailURL {
                do {
                    let stringURL = try String(contentsOf: detailURL) 
                    let document = try SwiftSoup.parse(stringURL) 
                    let title = try document.getElementsByClass("entry-title").eachText()
                    let details = try document.getElementsByClass("track-info")
                    var trackInfo = [String]()
                    
                    for _ in details.array() {
                        let eventText = try? details.text(trimAndNormaliseWhitespace: false) 
                        if let eventText = eventText {
                            let sortedCategories = eventText.components(separatedBy: "\n")
                            for i in sortedCategories {
                                let j = i.replacingOccurrences(of: "\r", with: "")
                                if j != "" {
                                    trackInfo.append(j.trimmingCharacters(in: .whitespaces)) 
                                }
                            }
                            self.trackInfo.append(MXTrackDetail(title: title[0], details: trackInfo))
                         }
                    }
                } catch {
                  print("An error has occured in DataServiceMXTrackDetail, fetchDetails: \(error)")
                }
            }
        }
    }
}
