import SwiftUI

struct GNCMainView: View {
    @ObservedObject var data: DataServiceGNCMain
    @ObservedObject var dataDetail: DataServiceGNCDetail
    @State private var showAlert = false 
    
    var body: some View {
        NavigationView {
            List {
                Text("Formatting may be incorrect. Please access the official GNC website for complete accurate information.")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        showAlert = true
                    }
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
            .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAlert) {
                Button("Yes") {
                    let url = URL(string: "https://gnccracing.com/events")
                    if let url = url {
                        UIApplication.shared.open(url)
                    }
                }
                Button("No", role: .cancel) { }
            }
        }
    }
}
