import SwiftUI

struct MXTrackView: View {
    let track: MXTrack 
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(track.track) 
            Text(track.trackInfo)
                .font(.caption.bold())
                .foregroundColor(.gray)
        }
    }
}
