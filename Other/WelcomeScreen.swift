import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<6) { 
                    Section(String($0)) {
                        ForEach(0..<2) {
                            Text(String($0))
                        }
                    }
                }
            }
            .redacted(reason: .placeholder)
            .disabled(true)
            .listStyle(.sidebar)
            .navigationTitle("ExaphyMoto")
        }
    }
}
