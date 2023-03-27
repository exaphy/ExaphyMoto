import SwiftUI

struct GNCMainView: View {
    @ObservedObject var data: DataServiceGNCMain
    
    var body: some View {
        NavigationView {
            List {
                ForEach(data.events) {
                    GNCEventView(event: $0)
                }
            }
            .navigationTitle("GNC Racing")
        }
    }
}
