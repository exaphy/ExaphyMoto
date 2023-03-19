import SwiftUI

struct GeneralInfo: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let generalInfo: [String]
}

struct OtherFees: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let otherFees: [String]
}

struct CostInfo: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let costInfo: [String]
}

struct SpecialInfo: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let specialInfo: [String]
}

struct Schedule: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let url: URL
    let schedule: [String]
}
