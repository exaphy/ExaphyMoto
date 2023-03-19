import SwiftUI

struct NGPCView: View {
    @ObservedObject var data: DataServiceNGPCMain
    @ObservedObject var dataDetail: DataServiceNGPCDetail
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var containedMonths: [String] {
        var initialMonths = [String]()
        for month in months {
            if data.events.filter({ $0.date.contains(month.prefix(3))}).count > 0 {
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
                        ForEach(data.events.filter { $0.date.contains(month.prefix(3))}) { event in
                            NavigationLink {
                                NGPCDetailView(data: dataDetail, event: event)
                                    .navigationTitle("Event Details")
                            } label: {
                                NGPCEventView(event: event)
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("NGPC")
        }
    }
}
