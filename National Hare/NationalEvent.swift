import SwiftUI

struct NationalEvent: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let date: String
}
