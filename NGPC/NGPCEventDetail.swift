import SwiftUI

struct Intro: Hashable {
    let url: URL
    let title: String
    let intro: [String]
}

struct GateTimes: Hashable {
    let title: String
    let gateTimes: [String]
}

struct GateFees: Hashable {
    let title: String
    let gateFees: [String]
}

struct SignUps: Hashable {
    let title: String
    let signUpLink: URL
    let signUps: [String]
}

struct EntryFees: Hashable {
    let title: String
    let entryFees: [String]
}

struct EventDetails: Hashable {
    let title: String
    let districtURL: URL
    let amaURL: URL
    let eventDetails: [String]
}

struct ClassInfo: Hashable {
    let title: String
    let classInfo: [String]
}

struct SkillLevels: Hashable {
    let title: String
    let skillLevels: [String]
}

struct Misc: Hashable {
    let title: String
    let info: [String]
}
