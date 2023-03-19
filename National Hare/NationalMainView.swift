import SwiftUI

struct NationalMainView: View {
    let data: DataServiceNationalMain
    let dataDetail: DataServiceNationalDetail
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var containedMonths: [String] {
        var initialMonths = [String]()
        for month in months {
            if data.events.filter({ $0.date.contains(month)}).count > 0 {
                initialMonths.append(month)
            }
        }
        return initialMonths
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(containedMonths, id: \.self) { month in
                    Section(month) {
                        ForEach(data.events.filter { $0.date.contains(month)}) { event in
                            NavigationLink {
                                NationalDetailView(details: dataDetail, event: event)
                                    .navigationTitle("Event Details")
                            } label: {
                                NationalEventView(event: event)
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("National Hare")
        }
    }
}
