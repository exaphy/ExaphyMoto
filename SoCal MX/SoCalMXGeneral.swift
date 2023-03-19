import SwiftUI

struct SoCalMXGeneral: Hashable, Identifiable {
    let id = UUID()
    let trackTimes: [String] 
    let procedures: [String] 
    let raceFees: [String] 
}
