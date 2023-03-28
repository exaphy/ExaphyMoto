import SwiftSoup
import SwiftUI

class DataServiceGNCDetail: ObservableObject {
    var urls = [URL]()
    var details = [GNCDetail]()
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
    
    func fetchDetails() {
        for url in urls {
            do {
                let stringURL = try String(contentsOf: url)
                let document = try SwiftSoup.parse(stringURL) 
                let title = try document.getElementsByClass("header_xl display_font").eachText() 
                var admissions = try document.getElementsByClass("ui_table ui_table_zebra mce-item-table").eachText()
                var otherAdmissions = try document.getElementsByClass("ui_table ui_table_zebra").eachText() 
                var details = try document.getElementsByClass("block_container text_content").eachText() 
                var unprocessedAdmissions = [String]()
                var processedAdmissions = [String]()
                var processedTitles = [String]()
                admissions = admissions.joined().components(separatedBy: "Adults (12+) Kids (6-11)")
                admissions = admissions.joined().components(separatedBy: "THURS")
                admissions = admissions.joined().components(separatedBy: "FRI")
                admissions = admissions.joined().components(separatedBy: "SUN")
                otherAdmissions = otherAdmissions.joined().components(separatedBy: "Adults (12+) Kids (6-11)")
                otherAdmissions = otherAdmissions.joined().components(separatedBy: "THURS")
                otherAdmissions = otherAdmissions.joined().components(separatedBy: "FRI")
                otherAdmissions = otherAdmissions.joined().components(separatedBy: "SUN")
                if admissions.count > 1 {
                    for i in admissions { 
                        var add = i.replacingOccurrences(of: "-", with: "")
                        add = add.trimmingCharacters(in: .whitespaces) 
                        if !add.isEmpty {
                            unprocessedAdmissions.append(add)
                        }
                    }  
                    for i in unprocessedAdmissions {
                        let add = i.replacingOccurrences(of: " ", with: "/")
                        processedAdmissions.append(add) 
                    }
                } else if otherAdmissions.count > 1 {
                    for i in otherAdmissions { 
                        var add = i.replacingOccurrences(of: "-", with: "")
                        add = add.trimmingCharacters(in: .whitespaces) 
                        if !add.isEmpty {
                            unprocessedAdmissions.append(add)
                        }
                    }  
                    for i in unprocessedAdmissions {
                        let add = i.replacingOccurrences(of: " ", with: "/")
                        processedAdmissions.append(add) 
                    }  
                }

                var unprocessedDetails = details.joined().components(separatedBy: "Special")
                let firstAdmissionsPosition = unprocessedDetails.firstIndex(where: { $0.contains("Adults (12+)")})
                if let firstAdmissionsPosition = firstAdmissionsPosition {
                    unprocessedDetails.remove(at: firstAdmissionsPosition) 
                }
                var preProcessDetails = [String]()
                for i in unprocessedDetails {
                    if i.contains("ized") {
                        preProcessDetails.append(i.replacingOccurrences(of: "ized", with: "Specialized"))
                    } else {
                        preProcessDetails.append(i) 
                    }
                }
                let processedDetails = preProcessDetails.joined()
                var sentences: [String] = []
                
                processedDetails.enumerateSubstrings(in: processedDetails.startIndex..<processedDetails.endIndex, options: [.bySentences]) { (substring, _, _, _) in
                    if let sentence = substring {
                        sentences.append(sentence)
                    }
                }

                for i in title {
                    processedTitles.append(i.replacingOccurrences(of: "Rd", with: "Round"))
                }
                self.details.append(GNCDetail(title: processedTitles[0], admissions: processedAdmissions, details: sentences))
            } catch {
                print("An error has occured in DataServiceGNCDetail, fetchDetails, for url in self.urls: \(error)")
            }
        }
    }
}
