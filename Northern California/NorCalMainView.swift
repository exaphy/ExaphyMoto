import SwiftUI

struct NorCalMainView: View {
    @ObservedObject var data: DataServiceNorCalMain
    @ObservedObject var dataDetail: DataServiceNorCalDetail
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Motocross") {
                    Text("More events are available on the official Northern California Motocross website.")
                        .foregroundColor(.blue) 
                        .onTapGesture {
                            showAlert = true
                        }
                    ForEach(data.motocrossEvents) { event in
                        NavigationLink {
                            NorCalMotocrossDetailView(event: dataDetail, eventMain: event)
                                .navigationTitle("Event Details")
                        } label: {
                            NorCalMotocrossView(event: event) 
                        }
                    }
                }
                
                Section("Cross Country") { 
                    ForEach(data.crossCountryEvents) { event in
                        NavigationLink {
                            NorCalCrossCountryDetailView(event: dataDetail, eventMain: event)
                                .navigationTitle("Event Details")
                        } label: {
                            NorCalCrossCountryView(event: event) 
                        }
                    }
                }
            }
            .navigationTitle("NorCal Motocross")
            .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAlert) {
                Button("Yes") {
                    let url = URL(string: "https://www.norcalmotocross.com/mec-category/motocross/")
                    if let url = url {
                        UIApplication.shared.open(url) 
                    }
                }
                Button("No", role: .cancel) { }
            }
        }
    }
}
