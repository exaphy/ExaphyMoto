import SwiftUI

struct NorCalMotocrossDetailView: View {
    @ObservedObject var event: DataServiceNorCalDetail
    @State private var showAlert = false
    let eventMain: NorCalMotocross
    
    var body: some View {
        List {
            ForEach(event.motocrossDetails) { 
                if $0.title == eventMain.event {
                    if !$0.website.isEmpty {
                        Text($0.website)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showAlert = true
                            }
                    }
                    LabeledContent("Date", value: $0.date)
                    LabeledContent("Time", value: $0.time)
                    if $0.location == "N/A" {
                        LabeledContent("Location", value: $0.location) 
                    } else {
                        Text($0.location)
                    }
                }
            }
        }
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAlert) {
            Button("Yes") {
                for i in event.motocrossDetails {
                    if i.title == eventMain.event {
                        if !i.website.isEmpty {
                            let url = URL(string: i.website.trimmingCharacters(in: .whitespaces)) 
                            if let url = url {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
            }
            Button("No", role: .cancel) { }
        }
    }
}
