import SwiftUI

struct GNCDetailView: View {
    @ObservedObject var details: DataServiceGNCDetail 
    @State private var showAlert = false 
    let event: GNCEvent
    
    var body: some View {
        List {
            ForEach(details.details, id: \.self) { detail in
                if detail.title == event.event {
                    Text(detail.title) 
                    Text("https://www.tixr.com/groups/gnccracing")
                        
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
