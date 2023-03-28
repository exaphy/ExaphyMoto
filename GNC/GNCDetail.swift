import SwiftUI

struct GNCDetail: Hashable, Identifiable {
    let id = UUID()
    let title: String 
    let url: URL
    let admissions: [String]
    let details: [String]
}
