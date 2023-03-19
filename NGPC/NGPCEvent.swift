import SwiftUI

struct NGPCEvent: Hashable, Identifiable {
    let id = UUID()
    let title: String 
    let date: String 
}
