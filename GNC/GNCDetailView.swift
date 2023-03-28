import SwiftUI

struct GNCDetailView: View {
    @ObservedObject var details: DataServiceGNCDetail 
    @State private var showAlert = false 
    @State private var showEventAlert = false
    let event: GNCEvent
    
    var body: some View {
        List {
            ForEach(details.details, id: \.self) { detail in
                if detail.title == event.event {
                    Text(detail.title) 
                    Text("Click here to buy tickets.")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showAlert = true
                        }
                    Text("Click here to access the event website.")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showEventAlert = true 
                        }
                        
                    Section("Online - Adults (12+) / Kids (6-11)") {
                        LabeledContent("Thurs - Sun", value: detail.admissions[0])
                        LabeledContent("Fri - Sun", value: detail.admissions[1])
                    }
                    GNCAdmissions(detail: detail) 
                    
                    ForEach(detail.details, id: \.self) {
                        Text($0.trimmingCharacters(in: .whitespaces)) 
                    }
                }
            }
        }
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAlert) { 
            Button("Yes") {
                let url = URL(string: "https://www.tixr.com/groups/gnccracing")
                if let url = url {
                    UIApplication.shared.open(url)
                }
            }
            Button("No", role: .cancel) { }
        }
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showEventAlert) {
            Button("Yes"){
                for i in details.details {
                    if i.title == event.event {
                        UIApplication.shared.open(i.url)
                    }
                }
            }
        }
    }
}

struct GNCAdmissions: View {
    let detail: GNCDetail
    
    var body: some View {
        Section("At the Gate - Adults (12+) / Kids (6-11)") {
            LabeledContent("Thurs - Sun", value: detail.admissions[2])
            LabeledContent("Fri - Sun", value: detail.admissions[3])
        }
    }
}
