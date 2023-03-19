import SwiftUI

struct NationalEventView: View {
    let event: NationalEvent
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
            Text(event.date)
                .foregroundColor(.gray)
                .font(.caption.bold())
        }
    }
}
