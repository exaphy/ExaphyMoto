import SwiftSoup
import SwiftUI

class DataServiceNorCalDetail: ObservableObject {
    var motocrossURLs = [String]()
    var crossCountryURLs = [String]()
    let motocrossURL = URL(string: "https://www.norcalmotocross.com/mec-category/motocross/")
    let crossCountryURL = URL(string: "https://www.norcalmotocross.com/mec-category/cross-country/")
    
    var motocrossDetails = [NorCalMotocrossDetail]()
    var crossCountryDetails = [NorCalCrossCountryDetails]()
    
    func fetchMotocrossURLs() {
        if let motocrossURL = motocrossURL {
            do {
                let stringURL = try String(contentsOf: motocrossURL) 
                let document = try SwiftSoup.parse(stringURL)
                let events = try document.getElementsByClass("mec-color-hover")
                
                for event in events.array() {
                    do {
                        motocrossURLs.append(try event.attr("href"))
                    } catch {
                        print("An error has occured in fetchMotocrossURLs, for event in events.array: \(error)")
                    }
                }
            } catch {
                print("An error has occured in DataServiceNorCalDetail, fetchMotocrossURLs: \(error)")
            }
        }
    }
    
    func fetchCrossCountryURLs() {
        if let crossCountryURL = crossCountryURL {
            do {
                let stringURL = try String(contentsOf: crossCountryURL) 
                let document = try SwiftSoup.parse(stringURL)
                let events = try document.getElementsByClass("mec-color-hover")
                
                for event in events.array() {
                    do {
                        crossCountryURLs.append(try event.attr("href"))
                    } catch {
                        print("An error has occured in fetchCrossCountryURLs, for event in events.array: \(error)")
                    }
                }
            } catch {
                print("An error has occured in DataServiceNorCalDetail, fetchCrossCountryURLs: \(error)")
            }
        }
    }
    
    func getMotocrossDetails() {
        for i in motocrossURLs {
            let url = URL(string: i) 
            if let url = url {
                do {
                    let stringURL = try String(contentsOf: url) 
                    let document = try SwiftSoup.parse(stringURL)
                    
                    let website = try document.getElementsByClass("mec-single-event-description mec-events-content").eachText()
                    let title = try document.getElementsByClass("mec-single-title").eachText()
                    let time = try document.getElementsByClass("mec-events-abbr").eachText()
                    let location = try document.getElementsByClass("mec-single-event-location").eachText()
                    let joinedWebsite = website.joined()
                    let finalWebsite = joinedWebsite.components(separatedBy: "Related")
                    let websitePosition = finalWebsite.firstIndex(where: { $0.contains("http")})
                    
                    if !location.isEmpty && motocrossDetails.filter ({ $0.title == title[0]}).isEmpty {
                        if let websitePosition = websitePosition {
                            motocrossDetails.append(NorCalMotocrossDetail(website: finalWebsite[websitePosition], title: title[0], date: time[0], time: time[1], location: location[0]))
                        } else {
                            motocrossDetails.append(NorCalMotocrossDetail(website: "", title: title[0], date: time[0], time: time[1], location: location[0]))
                        }
                    } else if location.isEmpty && motocrossDetails.filter ({ $0.title == title[0]}).isEmpty {
                        if let websitePosition = websitePosition {
                            motocrossDetails.append(NorCalMotocrossDetail(website: finalWebsite[websitePosition], title: title[0], date: time[0], time: time[1], location: "N/A"))
                        } else {
                            motocrossDetails.append(NorCalMotocrossDetail(website: "", title: title[0], date: time[0], time: time[1], location: "N/A"))
                        }
                    }
                } catch {
                    print("An error has occurd in getMotocrossDetails(): \(error)")
                }
            }
        }
    }
    
    func getCrossCountryDetails() {
        for i in crossCountryURLs {
            let url = URL(string: i) 
            if let url = url {
                do {
                    let stringURL = try String(contentsOf: url) 
                    let document = try SwiftSoup.parse(stringURL)
                    
                    let website = try document.getElementsByClass("mec-single-event-description mec-events-content").eachText()
                    let title = try document.getElementsByClass("mec-single-title").eachText()
                    let time = try document.getElementsByClass("mec-events-abbr").eachText()
                    let location = try document.getElementsByClass("mec-single-event-location").eachText()
                    let joinedWebsite = website.joined()
                    let finalWebsite = joinedWebsite.components(separatedBy: "Related")
                    let websitePosition = finalWebsite.firstIndex(where: { $0.contains("http")})
                    
                    if !location.isEmpty && crossCountryDetails.filter ({ $0.title == title[0]}).isEmpty {
                        if let websitePosition = websitePosition {
                            crossCountryDetails.append(NorCalCrossCountryDetails(website: finalWebsite[websitePosition], title: title[0], date: time[0], time: time[1], location: location[0]))
                        } else {
                            crossCountryDetails.append(NorCalCrossCountryDetails(website: "", title: title[0], date: time[0], time: time[1], location: location[0]))
                        }
                    } else if location.isEmpty && crossCountryDetails.filter ({ $0.title == title[0]}).isEmpty {
                        if let websitePosition = websitePosition {
                            crossCountryDetails.append(NorCalCrossCountryDetails(website: finalWebsite[websitePosition], title: title[0], date: time[0], time: time[1], location: "N/A"))
                        } else {
                            crossCountryDetails.append(NorCalCrossCountryDetails(website: "", title: title[0], date: time[0], time: time[1], location: "N/A"))
                        }
                    }
                } catch {
                    print("An error has occurd in getCrossCountryDetails(): \(error)")
                }
            }
        }
    }
}
