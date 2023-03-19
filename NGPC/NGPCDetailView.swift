import SwiftUI

struct NGPCDetailView: View {
    @ObservedObject var data: DataServiceNGPCDetail
    let event: NGPCEvent
    
    var body: some View {
        List {
            Section("General") {
                GeneralView(data: data, event: event)
            }
            
            Section("Gate Times") {
                GateTimeView(data: data, event: event)
            }
            
            Section("Gate Fees (Per Person)") {
                GateFeeView(data: data, event: event) 
            }
            
            Section("Sign Ups") {
                SignUpView(data: data, event: event)
            }
            
            Section("Entry Fees (Pre/Post)") {
                EntryFeeView(data: data, event: event)
            }
            
            Section("Event Details") {
                EventDetailsView(data: data, event: event)
                EventDetailsViewTwo(data: data, event: event)
            }
            
            Section("Class Info") {
                ClassInfoView(data: data, event: event) 
            }
            
            Section("Skill Levels") {
               SkillLevelView(data: data, event: event)
            }
            
            Section("Misc") {
                MiscView(data: data, event: event)
            }
        }
        .listStyle(.sidebar)
    }
}

struct GeneralView: View {
    @State private var showAlert = false
    let data: DataServiceNGPCDetail
    let event: NGPCEvent
    
    var body: some View {
        ForEach(data.intro, id: \.self) { intro in
            if intro.title == event.title { 
                ForEach(intro.intro, id: \.self) {
                    Text($0)
                }
            }
        }
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAlert) {
            Button("Yes") {
                for i in data.intro {
                    if i.title == event.title {
                        UIApplication.shared.open(i.url)
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

struct GateTimeView: View {
    let data: DataServiceNGPCDetail 
    let event: NGPCEvent
    
    var body: some View {
        ForEach(data.gateTimes, id: \.self) { 
            if $0.title == event.title {
                ForEach($0.gateTimes, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct GateFeeView: View {
    let data: DataServiceNGPCDetail
    let event: NGPCEvent
    
    var body: some View {
        ForEach(data.gateFees, id: \.self) {
            if $0.title == event.title {
                ForEach($0.gateFees, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct SignUpView: View {
    @State private var showAlert = false
    let data: DataServiceNGPCDetail
    let event: NGPCEvent
    
    var body: some View {
        ForEach(data.signUps, id: \.self) {
            if $0.title == event.title {
                ForEach($0.signUps, id: \.self) {
                    if $0.contains("Sign Up HERE") {
                        Text($0)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showAlert = true
                            }
                    } else {
                        Text($0)
                    }
                }
            }
        }
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAlert) {
            Button("Yes") {
                for i in data.signUps {
                    if i.title == event.title {
                        UIApplication.shared.open(i.signUpLink)
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

struct EntryFeeView: View {
    let data: DataServiceNGPCDetail
    let event: NGPCEvent
    
    var body: some View {
        ForEach(data.entryFees, id: \.self) {
            if $0.title == event.title {
                ForEach($0.entryFees, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct EventDetailsView: View {
    @State private var showDistrictAlert = false
    let data: DataServiceNGPCDetail
    let event: NGPCEvent
    
    var body: some View {
        ForEach(data.eventDetails, id: \.self) {
            if $0.title == event.title {
                ForEach($0.eventDetails, id: \.self) {
                 if $0.contains("www.AMADistrict37.org") {
                    Text($0)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showDistrictAlert = true
                        }
                 } else if $0.contains("Race Referee") || $0.contains("Steward") || $0.contains("Contact") {
                        Text($0).bold()
                 } else if $0.contains("www.AmericanMotorcyclist.com") {
                        
                } else {
                        Text($0)
                }
            }
        }
    }
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showDistrictAlert) {
            Button("Yes") {
                for i in data.eventDetails {
                    UIApplication.shared.open(i.districtURL)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

struct EventDetailsViewTwo: View {
    @State private var showAMAAlert = false
    let data: DataServiceNGPCDetail
    let event: NGPCEvent
    
    var body: some View {
        ForEach(data.eventDetails, id: \.self) {
            if $0.title == event.title {
                ForEach($0.eventDetails, id: \.self) {
                    if $0.contains("www.AmericanMotorcyclist.com") {
                        Text($0)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showAMAAlert = true
                            }
                    }
                }
            }
        }
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAMAAlert) {
            Button("Yes") {
                for i in data.eventDetails {
                    UIApplication.shared.open(i.amaURL)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

struct ClassInfoView: View {
    let data: DataServiceNGPCDetail
    let event: NGPCEvent
    
    var body: some View {
        ForEach(data.classInfo, id: \.self) {  
            if $0.title == event.title {
                ForEach($0.classInfo, id: \.self) {
                    if $0.contains("Adult") || $0.contains("Youth") || $0.contains("Vintage") && !$0.contains("Vintage:") {
                        Text($0).bold()
                    } else {
                        Text($0)
                    }
                }
            }
        }
    }
}

struct SkillLevelView: View {
    let data: DataServiceNGPCDetail
    let event: NGPCEvent 
        
    var body: some View {
        ForEach(data.skillLevels, id: \.self) {
            if $0.title == event.title {
                ForEach($0.skillLevels, id: \.self) {
                    if $0.contains("Adult") || $0.contains("Youth") {
                        Text($0).bold()
                    } else {
                        Text($0)
                    }
                }
            }
        }
    }
}
    
struct MiscView: View {
    let data: DataServiceNGPCDetail 
    let event: NGPCEvent
        
    var body: some View {
        ForEach(data.miscData, id: \.self) {
            if $0.title == event.title {
                ForEach($0.info, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}


