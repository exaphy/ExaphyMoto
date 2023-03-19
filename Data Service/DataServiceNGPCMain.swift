import SwiftSoup
import SwiftUI

class DataServiceNGPCMain: ObservableObject {
    var events = [NGPCEvent]()
    let baseURL = URL(string: "https://www.ngpcseries.com/events")
    
    func fetchEvents() {
        do {
            if let baseURL = baseURL {
                let urlString = try String(contentsOf: baseURL)
                let document = try SwiftSoup.parse(urlString)
                
                let eventText = try document.getElementsByClass("mec-color-hover").eachText()
                let eventDate = try document.getElementsByClass("mec-start-date-label").eachText()
                let endEventDate = try document.getElementsByClass("mec-end-date-label").eachText()
                for text in eventText {
                    var date = 0
                    if eventText.count > events.count {
                        date = eventDate[events.count].count
                    }
                    if date == 11 {
                        let newEvent = NGPCEvent(title: text, date: eventDate[events.count])
                        events.append(newEvent)
                    } else {
                        var count = 0
                        if eventText.count > events.count {
                            let begin = eventDate[events.count] 
                            let end = endEventDate[count]
                            let newEvent = NGPCEvent(title: text, date: "\(begin) \(end)")
                            count += 1
                            events.append(newEvent)
                        }
                    }
                }
            }
        } catch {
            print("An error has occured in DataServiceNGPCMain, fetchEvents: \(error)")
        }
    }
}
