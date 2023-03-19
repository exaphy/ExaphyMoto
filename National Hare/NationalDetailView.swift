import SwiftUI

struct NationalDetailView: View {
    let details: DataServiceNationalDetail
    let event: NationalEvent
    
    var body: some View {
        List {
            Section("General Info") {
                GeneralInfoNational(detail: details, event: event)
            }
            
            Section("Other Fees") {
                OtherFeesNational(detail: details, event: event)
            }
            
            Section("Costs") {
                CostNational(detail: details, event: event)
            }
            
            Section("Special") {
                SpecialNational(detail: details, event: event)
            }
            
            Section("Schedule") {
                ScheduleNational(detail: details, event: event)
            }
        }
        .listStyle(.sidebar)
    }
}

struct GeneralInfoNational: View {
    let detail: DataServiceNationalDetail
    let event: NationalEvent
    
    var body: some View {
        ForEach(detail.generalInfo) {
            if event.title.contains($0.title.suffix(1)) {
                ForEach($0.generalInfo, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct OtherFeesNational: View {
    let detail: DataServiceNationalDetail
    let event: NationalEvent
    
    var body: some View {
        ForEach(detail.otherFees) {
            if event.title.contains($0.title.suffix(1)) {
                ForEach($0.otherFees, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct CostNational: View {
    let detail: DataServiceNationalDetail
    let event: NationalEvent
    
    var body: some View {
        ForEach(detail.costInfo) {
            if event.title.contains($0.title.suffix(1)) {
                ForEach($0.costInfo, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct SpecialNational: View {
    let detail: DataServiceNationalDetail
    let event: NationalEvent
    
    var body: some View {
        ForEach(detail.specialInfo) {
            if event.title.contains($0.title.suffix(1)) {
                ForEach($0.specialInfo, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct ScheduleNational: View {
    @State private var showAlert = false 
    let detail: DataServiceNationalDetail
    let event: NationalEvent
    
    var body: some View {
        ForEach(detail.schedule) {
            if event.title.contains($0.title.suffix(1)) {
                Text("Due to limitations, please tap here to access the days the events correspond to.")
                    .onTapGesture {
                        showAlert = true
                    }
                    .foregroundColor(.blue)
                ForEach($0.schedule, id: \.self) {
                    Text($0)
                }
            }
        }
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAlert) {
            Button("Yes") {
                for i in detail.schedule {
                    if event.title.contains(i.title.suffix(1)) {
                        UIApplication.shared.open(i.url)
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

