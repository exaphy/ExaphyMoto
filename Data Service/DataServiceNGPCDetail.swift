import SwiftSoup
import SwiftUI

class DataServiceNGPCDetail: ObservableObject {
    var urls = [String]()
    let baseURL = URL(string: "https://www.ngpcseries.com/events")
    var addTimes = false
    
    var intro = [Intro]()
    var gateTimes = [GateTimes]()
    var gateFees = [GateFees]()
    var signUps = [SignUps]()
    var entryFees = [EntryFees]()
    var eventDetails = [EventDetails]()
    var classInfo = [ClassInfo]()
    var skillLevels = [SkillLevels]()
    var miscData = [Misc]()
    
    func fetchURLs() {
        if let baseURL = baseURL {
            do {
                let stringURL = try String(contentsOf: baseURL)
                let parser = try SwiftSoup.parse(stringURL)
                let details = try parser.getElementsByClass("mec-color-hover")
                
                for detail in details.array() {
                    do {
                        try urls.append(detail.attr("href"))
                    } catch {
                        print("An error has occured in DataServiceNGPCDetail, for details in details.array(): \(error)")
                    }
                }
            } catch {
                print("An error has occured in DataServiceNGPCDetail, if let detailURL = detailURL: \(error)")
            }
        }
    }
    
    func fetchDetails() {
        for url in urls {
            let newURL = URL(string: url) 
            
            do {
                if let newURL = newURL {
                    let stringURL = try String(contentsOf: newURL)
                    let document = try SwiftSoup.parse(stringURL)
                    
                    let retrievedTitle = try document.getElementsByClass("tt-heading-title").eachText()
                    let retrievedMain = try document.getElementsByClass("mec-single-event-description mec-events-content")
                    
                    for eventDetails in retrievedMain.array() {
                        var title = ""
                        let eventHTML = try eventDetails.text(trimAndNormaliseWhitespace: false)
                        let sortedCategories = eventHTML.components(separatedBy: "\n")
                        for i in retrievedTitle {
                            title = i
                        }
                        
                       let gateTimePosition = sortedCategories.firstIndex(where: { $0.contains("Gate Times")}) 
                        let gateFeePosition = sortedCategories.firstIndex(where: { $0.contains("Gate Fees")}) 
                        let signUpPosition = sortedCategories.firstIndex(where: { $0.contains("Sign Ups")})
                        let entryFeePosition = sortedCategories.firstIndex(where: { $0.contains("Entry Fees (Pre/Post)")})
                        let eventDetailPosition = sortedCategories.firstIndex(where: { $0.contains("Event Details")})
                        let classInfoPosition = sortedCategories.firstIndex(where: { $0.contains("Class Info")}) 
                        let skillLevelsPosition = sortedCategories.firstIndex(where: { $0.contains("Skill Levels")})
                        
                        var introDetails = [String]()
                        if let gateTimePosition = gateTimePosition { 
                            for i in 1...gateTimePosition {
                                if !sortedCategories[i].contains("Track Preview") && !sortedCategories[i].contains("Gate Times") && !sortedCategories[i].trimmingCharacters(in: .whitespaces).isEmpty && !sortedCategories[i].contains("Live Stream") {
                                    introDetails.append(sortedCategories[i].trimmingCharacters(in: .whitespaces))  
                                  }
                            }
                        }
                        
                        var gateTime = [String]()
                        if let gateTimePosition = gateTimePosition {
                            if let gateFeePosition = gateFeePosition {
                                let calculatedDistance = gateFeePosition - gateTimePosition
                                for i in 1...calculatedDistance {
                                    if !sortedCategories[gateTimePosition + i].contains("Gate Fees") {
                                        gateTime.append(sortedCategories[gateTimePosition + i].trimmingCharacters(in: .whitespaces))
                                    }
                                }
                            }
                        }
                        
                        var gateFee = [String]()
                        if let gateFeePosition = gateFeePosition {
                            if let signUpPosition = signUpPosition {
                                let calculatedPosition = signUpPosition - gateFeePosition
                                for i in 0...calculatedPosition {
                                    if !sortedCategories[gateFeePosition + i].contains("Sign Ups") && !sortedCategories[gateFeePosition + i].contains("Gate Fees (per person):") {
                                        gateFee.append(sortedCategories[gateFeePosition + i].trimmingCharacters(in: .whitespaces))
                                    }                               
                                }
                            }
                        }
                        
                        var signUp = [String]()
                        if let entryFeePosition = entryFeePosition {
                            if let signUpPosition = signUpPosition {
                                let calculatedDistance = entryFeePosition - signUpPosition 
                                for i in 0...calculatedDistance {
                                    if !sortedCategories[signUpPosition + i].contains("Sign Ups:") && !sortedCategories[signUpPosition + i].contains("Entry Fees (Pre/Post") {
                                        signUp.append(sortedCategories[signUpPosition + i].trimmingCharacters(in: .whitespaces))
                                    }
                                }
                            }
                        }
                        
                        var entryFee = [String]()
                        if let entryFeePosition = entryFeePosition {
                            if let eventDetailPosition = eventDetailPosition {
                                let calculatedDistance = eventDetailPosition - entryFeePosition 
                                for i in 0...calculatedDistance {
                                    if !sortedCategories[entryFeePosition + i].contains("Event Details") && !sortedCategories[entryFeePosition + i].contains("Entry Fees (Pre/Post") &&  !sortedCategories[entryFeePosition + i].trimmingCharacters(in: .whitespaces).isEmpty {
                                        entryFee.append(sortedCategories[entryFeePosition + i].trimmingCharacters(in: .whitespaces))
                                    }                               
                                }
                            }
                        }
                        
                        var eventDetail = [String]() 
                        if let eventDetailPosition = eventDetailPosition {
                            if let classInfoPosition = classInfoPosition {
                                let calculatedDistance = classInfoPosition - eventDetailPosition 
                                for i in 0...calculatedDistance {
                                    if !sortedCategories[eventDetailPosition + i].contains("Event Details") && !sortedCategories[eventDetailPosition + i].contains("Class Info") &&  !sortedCategories[eventDetailPosition + i].trimmingCharacters(in: .whitespaces).isEmpty {
                                        eventDetail.append(sortedCategories[eventDetailPosition + i].trimmingCharacters(in: .whitespaces))
                                    } 
                                }
                            }
                        }
                        
                        var classDetails = [String]()
                        if let skillLevelsPosition = skillLevelsPosition {
                            if let classInfoPosition = classInfoPosition {
                                let calculatedDistance = skillLevelsPosition - classInfoPosition 
                                for i in 0...calculatedDistance {
                                    if !sortedCategories[classInfoPosition + i].contains("Skill Levels") && !sortedCategories[classInfoPosition + i].contains("Class Info") &&  !sortedCategories[classInfoPosition + i].trimmingCharacters(in: .whitespaces).isEmpty {
                                        classDetails.append(sortedCategories[classInfoPosition + i].trimmingCharacters(in: .whitespaces))
                                    } 
                                }
                            }
                        }
                        
                        var skillLevel = [String]()
                        if let miscPosition = sortedCategories.firstIndex(where: { $0.contains("Misc. Info")}) {
                            if let skillLevelsPosition = skillLevelsPosition {
                                let calculatedDistance = miscPosition - skillLevelsPosition
                                for i in 0...calculatedDistance {
                                    if !sortedCategories[skillLevelsPosition + i].contains("Skill Levels") && !sortedCategories[skillLevelsPosition + i].contains("Misc. Info") {
                                        skillLevel.append(sortedCategories[skillLevelsPosition + i].trimmingCharacters(in: .whitespaces))
                                    } 
                                }
                            }
                        }
                    
                        var misc = [String]()
                        if let miscPosition = sortedCategories.firstIndex(where: { $0.contains("Misc. Info")}) {
                            let calculatedDistance = (sortedCategories.count - miscPosition) - 1
                            for i in 0...calculatedDistance {
                                if !sortedCategories[miscPosition + i].trimmingCharacters(in: .whitespaces).isEmpty && !sortedCategories[miscPosition + i].contains("Misc. Info") {
                                    misc.append(sortedCategories[miscPosition + i].trimmingCharacters(in: .whitespaces))

                                } 
                            }
                        }
                    
                        if intro.filter({ $0.title == title }).count == 0 {
                            intro.append(Intro(url: newURL, title: title, intro: introDetails))
                            }
                        if gateTimes.filter({ $0.title == title}).count == 0 {
                            gateTimes.append(GateTimes(title: title, gateTimes: gateTime))
                        }
                        if gateFees.filter({ $0.title == title}).count == 0 {
                            gateFees.append(GateFees(title: title, gateFees: gateFee))
                        }
                        let signUpLink = URL(string: "http://entergp.com/")
                        if let signUpLink = signUpLink {
                            if signUps.filter({ $0.title == title}).count == 0 {
                                signUps.append(SignUps(title: title, signUpLink: signUpLink, signUps: signUp))
                            }
                        }
                        if entryFees.filter({ $0.title == title}).count == 0 {
                            entryFees.append(EntryFees(title: title, entryFees: entryFee))
                        }
                        let districtURL = URL(string: "https://www.amadistrict37.org/series-registration.html")
                        let amaURL = URL(string: "https://americanmotorcyclist.com/join-the-ama/")
                        if let amaURL = amaURL {
                            if let districtURL = districtURL {
                                if self.eventDetails.filter({ $0.title == title}).count == 0 {
                                    self.eventDetails.append(EventDetails(title: title, districtURL: districtURL, amaURL: amaURL, eventDetails: eventDetail))
                                }
                            }
                        }
                        if classInfo.filter({ $0.title == title}).count == 0 {
                            classInfo.append(ClassInfo(title: title, classInfo: classDetails))
                        }
                        if skillLevels.filter({ $0.title == title}).count == 0 {
                            skillLevels.append(SkillLevels(title: title, skillLevels: skillLevel))
                        }
                        if miscData.filter({ $0.title == title}).count == 0 {
                            miscData.append(Misc(title: title, info: misc))
                        }
                    }
                }
            } catch {
                print("An error has occured in DataServiceNGPCDetail, fetchDetails(title: String), for url in urls: \(error)")
            }
        }
    }
}
