import SwiftSoup
import SwiftUI

class DataServiceSoCalMain: ObservableObject {
    var details = [SoCalMXGeneral]()
    var events = [SoCalMXEvent]()
    let url = URL(string: "https://socalotmx.org/race-info")
    
    func fetchEvents() {
        if let url = url {
            do {
                let stringURL = try String(contentsOf: url) 
                let document = try SwiftSoup.parse(stringURL)
                let events = try document.getElementsByClass("sqs-block-content").eachText()
                                    
                let schedulePositon = events.firstIndex(where: { $0.contains("2023 SCHEDULE")})
                let raceDayPosition = events.firstIndex(where: { $0.contains("GENERAL RACE DAY INFORMATION")})
                
                if let raceDayPosition = raceDayPosition {
                    let separatedRaceDay = events[raceDayPosition].components(separatedBy: "GENERAL RACE DAY INFORMATION")
                    let trackOpeningPosition = separatedRaceDay.firstIndex(where: { $0.contains("TRACK OPENING TIMES")})
                    if let trackOpeningPosition = trackOpeningPosition {
                        let separatedTrackDay = separatedRaceDay[trackOpeningPosition].components(separatedBy: "TRACK OPENING TIMES:")
                        var separatedProcedures = separatedTrackDay[trackOpeningPosition].components(separatedBy: "GENERAL RACE DAY PROCEDURES:")
                        let unprocessedTrackTimes = separatedProcedures[trackOpeningPosition - 1] 
                        let splitTrackTimes = unprocessedTrackTimes.components(separatedBy: "am")
                        var trackTimes = [String]()
                        for i in splitTrackTimes {
                            var j = i
                            if i != " " {
                                j = i + "am"
                                trackTimes.append(j.trimmingCharacters(in: .whitespaces))
                            }
                        }
                        separatedProcedures.remove(at: trackOpeningPosition - 1)
                        
                        var separatedRaceFees = separatedProcedures[trackOpeningPosition - 1].components(separatedBy: "RACE FEES:")
                        let unprocessedProcedures = separatedRaceFees[trackOpeningPosition - 1]
                        let splitProcedures = unprocessedProcedures.components(separatedBy: ".")
                        var procedures = [String]()
                        for i in splitProcedures {
                            if i.contains("1st Practice") {
                                let separatedFirst = i.components(separatedBy: "1st") 
                                for j in separatedFirst {
                                    var k = j
                                    if j.contains("Practice") {
                                        k = "1st\(j)"
                                        procedures.append(k.trimmingCharacters(in: .whitespaces))
                                    } else {
                                        procedures.append(j.trimmingCharacters(in: .whitespaces)) 
                                    }
                                }
                            } else {
                                if i != " " {
                                    procedures.append(i.trimmingCharacters(in: .whitespaces))
                                }
                            }
                        }
                        separatedRaceFees.remove(at: trackOpeningPosition - 1)
                        
                        var separatedRace = separatedRaceFees[trackOpeningPosition - 1].components(separatedBy: "Race Fees:")
                        var raceFees = [String]()
                        raceFees.append(separatedRace[trackOpeningPosition - 1].trimmingCharacters(in: .whitespaces))
                        separatedRace.remove(at: trackOpeningPosition - 1) 
                        
                        var separatedMemberFees = separatedRace[trackOpeningPosition - 1].components(separatedBy: "Adult Mini-Moto as a 2nd Class:")
                        let splitMemberFee = separatedMemberFees[trackOpeningPosition - 1].components(separatedBy: "$")
                        for i in splitMemberFee {
                            var j = i
                            if !i.contains("50") {
                                if i != " " {
                                    if i.contains("Member") {
                                        j = i + "$50"
                                        raceFees.append(j.trimmingCharacters(in: .whitespaces))
                                    } else if i.contains("Non-Member") {
                                        j = i + "$55"
                                        raceFees.append(j.trimmingCharacters(in: .whitespaces))
                                    } else {
                                        j = i + "$50"
                                        raceFees.append(j.trimmingCharacters(in: .whitespaces)) 
                                    }
                                }
                            }
                        }
                        separatedMemberFees.remove(at: trackOpeningPosition - 1) 
                        
                        var separatedTransponder = separatedMemberFees[trackOpeningPosition - 1].components(separatedBy: "Transponder")
                        let splitClassFees = separatedTransponder[trackOpeningPosition - 1].components(separatedBy: "Member")
                        for i in splitClassFees {
                            var j = i
                            if i.contains("$10") {
                                j = "Adult Mini-Moto as a 2nd Class:\(i)"
                                raceFees.append(j.trimmingCharacters(in: .whitespaces))
                            } else {
                                raceFees.append(j.trimmingCharacters(in: .whitespaces))
                            }
                        }
                        separatedTransponder.remove(at: trackOpeningPosition - 1)
                        
                        for i in separatedTransponder {
                            var j = i
                            j = "Transponder\(i)"
                            raceFees.append(j.trimmingCharacters(in: .whitespaces)) 
                        }
                        
                        details.append(SoCalMXGeneral(trackTimes: trackTimes, procedures: procedures, raceFees: raceFees))
                    }
                }
    
               if let schedulePosition = schedulePositon {
                    if let raceDayPosition = raceDayPosition {
                       let calculatedDistance = raceDayPosition - schedulePosition 
                        for i in 0...calculatedDistance {
                            if !events[schedulePosition + i].contains("GENERAL RACE DAY INFORMATION") && !events[schedulePosition + i].contains("2023 SCHEDULE") {      
                                let separated = events[schedulePosition + i].components(separatedBy: ")")

                                for unprocessed in separated {
                                   if unprocessed != "" {
                                       var processed = unprocessed
                                       if unprocessed.contains("(") && !unprocessed.contains("Apr 23") && !unprocessed.contains("TBD") {
                                           processed = unprocessed + ")"
                                           self.events.append(SoCalMXEvent(title: processed.trimmingCharacters(in: .whitespaces)))
                                       }
                                       
                                       if unprocessed.contains("Apr 23") {
                                           var finalArray = [String]()
                                           var LACRSplit = unprocessed.components(separatedBy: "Apr")
                                           let LACRPosition = LACRSplit.firstIndex(where: { $0.contains("LACR")})
                                           let aprilPosition = LACRSplit.firstIndex(where: { !$0.contains("Mar")})
                                           
                                           var LACR = ""
                                           if let LACRPosition = LACRPosition {
                                               LACR = LACRSplit[LACRPosition]
                                               LACRSplit.remove(at: LACRPosition)
                                               LACR = "Apr\(LACR)\(")")"
                                           }
                                           
                                           var april = [String]()
                                           if let aprilPosition = aprilPosition {
                                               april = LACRSplit.filter { !$0.contains("Mar")}
                                               for _ in aprilPosition..<LACRSplit.count {
                                                   LACRSplit.remove(at: aprilPosition) 
                                               }
                                           }
                                           
                                           let marchSplit = LACRSplit.joined().components(separatedBy: "Mar")
                                           
                                           for i in april {
                                               var finalApril = i
                                               finalApril = "Apr\(i)"
                                               finalArray.append(finalApril)
                                           }
                                           for i in marchSplit {
                                               var finalMarch = i
                                               if i != " " {
                                                   finalMarch = "Mar\(i)"
                                               }
                                               finalArray.append(finalMarch)
                                           }
                                           finalArray.append(LACR)
                                           for i in finalArray {
                                               self.events.append(SoCalMXEvent(title: i.trimmingCharacters(in: .whitespaces)))
                                           }
                                     }
                                       
                                       if unprocessed.contains("TBD") {
                                           let processed = unprocessed.components(separatedBy: "Jun")
                                           var finalArray = [String]()
                                           for i in processed {
                                               if i.contains("May") {
                                                   finalArray.append(i)
                                               } else {
                                                   let finalVersion = "Jun\(i))"
                                                   finalArray.append(finalVersion)
                                                 }
                                           }
                                           for i in finalArray {
                                               self.events.append(SoCalMXEvent(title: i.trimmingCharacters(in: .whitespaces)))
                                           }
                                       }
                                    }
                               }
                            }
                        }
                    }
                }
            } catch {
                print("An error has occured in DataServiceNationalMain, fetchEvents: \(error)")
            }
        }
    }
}
