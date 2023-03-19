import SwiftUI

struct MXTrackMainView: View {
    @ObservedObject var data: DataServiceMXTrack
    @ObservedObject var dataDetail: DataServiceMXTrackDetail
    @State private var searchText = ""
    var filteredTracks: [MXTrack] {
        if searchText.isEmpty {
            return data.tracks 
        } else {
            return data.tracks.filter { $0.track.localizedCaseInsensitiveContains(searchText) || $0.trackInfo.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredTracks) { track in
                    NavigationLink {
                        MXTrackDetailView(data: dataDetail, track: track)
                            .navigationTitle("Track Details")
                    } label: {
                        MXTrackView(track: track)
                }
            }
        }        
            .navigationTitle("MX Track Guide")
            .searchable(text: $searchText, prompt: "Search for a track by name or location")
        }
    }
}
