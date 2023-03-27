import SwiftUI

struct GNCEventView: View {
    let event: GNCEvent
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.event) 
            Text(event.date)
                .font(.caption.bold())
                .foregroundColor(.gray)
        }
    }
}
