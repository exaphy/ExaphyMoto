import SwiftUI

struct MXTrackDetailView: View {
    @ObservedObject var data: DataServiceMXTrackDetail
    let track: MXTrack
    var website: Bool {
        for i in data.trackInfo {
            if i.title == track.track {
                for j in i.details {
                    if j.contains("http") {
                        return true 
                    }
                }
            }
        }
        return false 
    }
    
    var body: some View {
        List {
            Section {
                ForEach(data.trackInfo) {
                    if $0.title == track.track {
                        ForEach($0.details, id: \.self) {
                            if $0.contains("http") {
                                MXTrackWebsite(data: data, track: track) 
                            } else {
                                Text($0)
                            }
                        }
                    }
                }    
            } header: {
                Text("Track Details")
            } footer: {
                if website {
                    Text("Press and hold on the website to access it.")
                }
            }
        }
    }
}

struct MXTrackWebsite: View {
    @ObservedObject var data: DataServiceMXTrackDetail 
    @State private var showAlert = false 
    let track: MXTrack
    
    var body: some View {
        ForEach(data.trackInfo) {
            if $0.title == track.track {
                ForEach($0.details, id: \.self) {
                    if $0.contains("http") {
                        Text($0)
                            .contextMenu {
                                Button("Open Website") {
                                    showAlert = true 
                                }
                            }
                    }
                }
            }
        }    
        .alert("You are about to leave ExaphyMoto. Are you sure?", isPresented: $showAlert) {
            Button("Yes") {
                for i in data.trackInfo {
                    if i.title == track.track {
                        for j in i.details {
                            if j.contains("http") {
                                let newWebsite = j.replacingOccurrences(of: "Website:", with: "")
                                let finalURL = newWebsite.trimmingCharacters(in: .whitespaces)
                                let websiteURL = URL(string: finalURL)
                                if let websiteURL = websiteURL {
                                    UIApplication.shared.open(websiteURL)
                                }
                            }
                        }
                    }
                }
            }
            Button("No", role: .cancel) { }
        }
    }
}
