import SwiftSoup
import SwiftUI

class DataServiceGNCMain: ObservableObject {
    var events = [GNCEvent]()
    let baseURL = URL(string: "https://gnccracing.com/events")
    
    func fetchEvents() {
        if let baseURL = baseURL {
            do {
                let stringURL = try String(contentsOf: baseURL) 
                let document = try SwiftSoup.parse(stringURL)
                let titles = try document.getElementsByClass("link_title").eachText()
                let unprocessedDates = try document.getElementsByClass(" date").select("span").eachText()
                
                var processedDates = unprocessedDates
                for i in unprocessedDates {
                    if i.contains("Fri") || i.contains("Sat") || i.contains("Sun") {
                        let firstPosition = processedDates.firstIndex(of: i) 
                        if let firstPosition = firstPosition {
                            processedDates.remove(at: firstPosition)
                        }
                    }
                }
                
                var finalDates = [String]()
                for i in processedDates {
                    let firstPosition = processedDates.firstIndex(where: { $0.contains(i)})
                    if let firstPosition = firstPosition {
                        if firstPosition % 2 == 0 {
                            finalDates.append("\(processedDates[firstPosition]) - \(processedDates[firstPosition + 1])")
                        }
                    }
                }
                
                var finalTitles = [String]() 
                for i in titles {
                    finalTitles.append(i.replacingOccurrences(of: "Rd", with: "Round"))
                }

                for i in finalTitles {
                    let firstPosition = finalTitles.firstIndex(where: { $0.contains(i)})
                    if let firstPosition = firstPosition {
                        events.append(GNCEvent(event: i, date: finalDates[firstPosition]))
                    }
                }
            } catch {
                print("An error has occured in DataServiceGNCMain, fetchEvents: \(error)")
            }
        }
    }
}
