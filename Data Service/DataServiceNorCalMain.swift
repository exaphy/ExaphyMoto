import SwiftSoup 
import SwiftUI

class DataServiceNorCalMain: ObservableObject {
    var motocrossEvents = [NorCalMotocross]()
    var crossCountryEvents = [NorCalCrossCountry]()
    let motocrossURL = URL(string: "https://www.norcalmotocross.com/mec-category/motocross/")
    let crossCountryURL = URL(string: "https://www.norcalmotocross.com/mec-category/cross-country/")
    
    func fetchMotocross() {
        if let motocrossURL = motocrossURL {
            do {
                let stringURL = try String(contentsOf: motocrossURL) 
                let document = try SwiftSoup.parse(stringURL) 
                let dates = try document.getElementsByClass("mec-start-date-label").eachText() 
                let events = try document.getElementsByClass("mec-color-hover").eachText()
                var j = 0
                for i in events {
                    motocrossEvents.append(NorCalMotocross(event: i, date: dates[j]))
                    j += 1
                }
               } catch {
                print("An error has occured in DataServiceNorCalMain, fetchMotocross: \(error)")
            }
        }
    }
    
    func fetchCrossCountry() {
        if let crossCountryURL = crossCountryURL {
            do {
                let stringURL = try String(contentsOf: crossCountryURL) 
                let document = try SwiftSoup.parse(stringURL) 
                let dates = try document.getElementsByClass("mec-start-date-label").eachText() 
                let events = try document.getElementsByClass("mec-color-hover").eachText()
                var j = 0
                for i in events {
                    crossCountryEvents.append(NorCalCrossCountry(event: i, date: dates[j]))
                    j += 1
                }
            } catch {
                print("An error has occured in DataServiceNorCalMain, fetchCrossCountry: \(error)")
            }
        }
    }

}
