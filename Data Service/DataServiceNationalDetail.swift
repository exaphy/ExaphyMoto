import SwiftSoup
import SwiftUI

class DataServiceNationalDetail: ObservableObject {
    var urls = [String]()
    let url = URL(string: "https://nationalhareandhound.com/2022schedule/")
    
    var generalInfo = [GeneralInfo]()
    var otherFees = [OtherFees]()
    var costInfo = [CostInfo]()
    var specialInfo = [SpecialInfo]()
    var schedule = [Schedule]()
    
    func fetchURLs() {
        do {
            if let url = url {
                let stringURL = try String(contentsOf: url) 
                let document = try SwiftSoup.parse(stringURL)
                let urlsOne = try document.getElementsByClass("w-ibanner us_custom_12c75124 zindexing has_text_color animation_phorcys ratio_4x3 easing_ease").select("a")
                let urlsTwo = try document.getElementsByClass("w-ibanner us_custom_12c75124 has_text_color animation_phorcys ratio_4x3 easing_ease").select("a")
                
                for i in urlsOne.array() {
                   try urls.append(i.attr("href"))
                }
                for i in urlsTwo.array() {
                    try urls.append(i.attr("href"))
                }
            }
        } catch {
            print("An error has occured in DataServiceNationalDetail, fetchURLs: \(error)")
        }
    }
    
    func fetchDetails() {
        for url in urls {
            let newURL = URL(string: url)
            if let newURL = newURL {
                do {
                    var round = ""
                    let stringURL = try String(contentsOf: newURL) 
                    let document = try SwiftSoup.parse(stringURL)
                    
                    let retrievedDetails = try document.getElementsByClass("wpb_wrapper")
                    let retrievedSchedule = try document.getElementsByClass("aio-icon-header").eachText()
                    
                    for detail in retrievedDetails {
                        let eventHTML = try detail.text(trimAndNormaliseWhitespace: false)
                        let sortedCategories = eventHTML.components(separatedBy: "\n")
                        let generalInfoPosition = sortedCategories.firstIndex(where: { $0.contains("GENERAL INFO")})
                        let otherFeesPosition = sortedCategories.firstIndex(where: { $0.contains("Other Fees")})
                        let costPosition = sortedCategories.firstIndex(where: { $0.contains("What’s it going to cost me to show up and race?")})
                        let specialPosition = sortedCategories.firstIndex(where: { $0.contains("Anything special I need to bring for this race?")})
                        let schedulePosition = sortedCategories.firstIndex(where: { $0.contains("Schedule")})
                    
                        var generalInfo = [String]()
                        if let generalInfoPosition = generalInfoPosition { 
                            if let otherFeesPosition = otherFeesPosition {
                                let calculatedDistance = otherFeesPosition - generalInfoPosition
                                for i in 0...calculatedDistance {
                                    if !sortedCategories[generalInfoPosition + i].contains("Other Fees") && !sortedCategories[generalInfoPosition + i].contains("GENERAL INFO") && sortedCategories[generalInfoPosition + i] != "" {
                                        generalInfo.append(sortedCategories[generalInfoPosition + i].trimmingCharacters(in: .whitespaces))
                                   }
                                }
                            }
                        }
                        
                        var otherFees = [String]()
                        if let costPosition = costPosition { 
                            if let otherFeesPosition = otherFeesPosition {
                                let calculatedDistance = costPosition - otherFeesPosition
                                for i in 0...calculatedDistance {
                                    if !sortedCategories[otherFeesPosition + i].contains("What’s it going to cost me to show up and race?") && !sortedCategories[otherFeesPosition + i].contains("Other Fees") && sortedCategories[otherFeesPosition + i] != " " && sortedCategories[otherFeesPosition + i] != "" {
                                        otherFees.append(sortedCategories[otherFeesPosition + i].trimmingCharacters(in: .whitespaces))
                                    } 
                                }
                            }
                        }
                        
                        var costs = [String]()
                        if let costPosition = costPosition { 
                            if let specialPosition = specialPosition {
                                let calculatedDistance = specialPosition - costPosition
                                for i in 0...calculatedDistance {
                                    if !sortedCategories[costPosition + i].contains("What’s it going to cost me to show up and race?") && !sortedCategories[costPosition + i].contains("Anything special I need to bring for this race?") && sortedCategories[costPosition + i] != "" && sortedCategories[costPosition + i] != " " {
                                        costs.append(sortedCategories[costPosition + i].trimmingCharacters(in: .whitespaces))
                                    }
                                }
                            }
                            
                            var special = [String]()
                            if let specialPosition = specialPosition {
                                for i in specialPosition..<sortedCategories.count {
                                    if !sortedCategories[i].contains("Anything special I need to bring for this race?") && sortedCategories[i] != "" && sortedCategories[i] != " " {
                                        special.append((sortedCategories[i]).trimmingCharacters(in: .whitespaces))
                                    }
                                }
                            }
                            
                            var schedule = [String]()
                            for i in retrievedSchedule {
                                schedule.append(i)
                            }
                        
                            for i in generalInfo {
                            if i.contains("Which round is it?") {
                               round = i
                                if self.generalInfo.filter({ $0.title.contains(round)}).count == 0 {
                                    self.generalInfo.append(GeneralInfo(title: round, generalInfo: generalInfo))
                                    }
                                
                                if self.otherFees.filter({ $0.title.contains(round)}).count == 0 {
                                    self.otherFees.append(OtherFees(title: round, otherFees: otherFees))
                                }
                                
                                if costInfo.filter({ $0.title.contains(round)}).count == 0 {
                                    self.costInfo.append(CostInfo(title: round, costInfo: costs))
                                }
                                
                                if specialInfo.filter({ $0.title.contains(round)}).count == 0 {
                                    self.specialInfo.append(SpecialInfo(title: round, specialInfo: special))
                                }
                                
                                if self.schedule.filter({ $0.title.contains(round)}).count == 0 {
                                    self.schedule.append(Schedule(title: round, url: newURL, schedule: schedule))
                                }
                            }
                        }
                    }
                }
                } catch {
                //    print("An error has occured in DataServiceNationalDetail, fetchDetails: \(error)")
                }
            }
        }
    }
}
