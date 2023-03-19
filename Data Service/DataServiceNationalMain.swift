import SwiftSoup
import SwiftUI

class DataServiceNationalMain: ObservableObject {
    var events = [NationalEvent]()
    let url = URL(string: "https://nationalhareandhound.com/2022schedule/")
    
    func fetchEvents() {
        if let url = url {
            do {
                let stringURL = try String(contentsOf: url) 
                let document = try SwiftSoup.parse(stringURL)
                
                let events = try document.getElementsByClass("w-ibanner-title").eachText()
                let dates = try document.getElementsByClass("w-ibanner-desc").eachText()
                var count = 0
                for event in events {
                    self.events.append(NationalEvent(title: event, date: dates[count]))
                    count += 1
                }
            } catch {
                print("An error has occured in DataServiceNationalMain, fetchEvents: \(error)")
            }
        }
    }
}
