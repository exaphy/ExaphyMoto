import SwiftSoup
import SwiftUI

class DataServiceGNCDetail: ObservableObject {
    var urls = [URL]()
    let eventURL = URL(string: "https://gnccracing.com/events")
    let baseURL = URL(string: "https://gnccracing.com")
    
    func fetchURLs() {
        if let eventURL = eventURL {
            do {
                let stringURL = try String(contentsOf: eventURL)
                let document = try SwiftSoup.parse(stringURL) 
                let urls = try document.getElementsByClass("ui_link big_link")
                
                for url in urls.array() {
                    let newURL = baseURL?.appendingPathComponent(try url.attr("href"))
                    if let newURL = newURL {
                        self.urls.append(newURL)
                    }
                }
            } catch {
                print("An error has occured in DataServiceGNCDetail, fetchURLs: \(error)")
            }
        }
    }
}
