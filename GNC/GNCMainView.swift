import SwiftUI

struct GNCMainView: View {
    @ObservedObject var data: DataServiceGNCMain
    @ObservedObject var dataDetail: DataServiceGNCDetail
    
    var body: some View {
        NavigationView {
            List {
                ForEach(data.events) { event in
                    NavigationLink {
                        GNCDetailView(details: dataDetail, event: event)  
                            .navigationTitle("Event Details") 
                    } label: {
                        GNCEventView(event: event)
                    }
                }
            }
            .navigationTitle("GNC Racing")
        }
    }
}
