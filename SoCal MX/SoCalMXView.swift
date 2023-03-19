import SwiftUI

struct SoCalMXView: View {
    @ObservedObject var data: DataServiceSoCalMain
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    var body: some View {
        NavigationView {
            List {
                Section("Track Opening Times") {
                    SoCalTrackOpenTimes(data: data)
                }
                
                Section("General Race Day Procedures") {
                    SoCalProcedures(data: data) 
                }
                
                Section("Race Fees") {
                    SoCalRaceFees(data: data)
                }
                
                ForEach(months, id: \.self) { month in 
                    Section(month) {
                        ForEach(data.events.filter { $0.title.contains(month.prefix(3))}) {
                            Text($0.title) 
                        }
                    }
                } 
               }
            .listStyle(.sidebar)
            .navigationTitle("SoCal MX")
        }
    }
}

struct SoCalTrackOpenTimes: View {
    let data: DataServiceSoCalMain
    
    var body: some View {
        ForEach(data.details) {
            ForEach($0.trackTimes, id: \.self) {
                Text($0)
            }
        }
    }
}


struct SoCalProcedures: View {
    let data: DataServiceSoCalMain
    
    var body: some View {
        ForEach(data.details) {
            ForEach($0.procedures, id: \.self) {
                Text($0)
            }
        }
    }
}

struct SoCalRaceFees: View {
    let data: DataServiceSoCalMain
    
    var body: some View {
        ForEach(data.details) {
            ForEach($0.raceFees, id: \.self) {
                Text($0)
            }
        }
    }
}
