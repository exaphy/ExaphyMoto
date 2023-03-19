import SwiftUI

struct MXTrackDetail: Hashable, Identifiable {
    let id = UUID() 
    let title: String 
    let details: [String]
}
