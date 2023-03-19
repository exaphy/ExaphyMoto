import SwiftUI

struct NGPCEventView: View {
    let event: NGPCEvent
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title) 
            Text(event.date) 
                .foregroundColor(.gray)
                .font(.caption.bold())
        }
    }
}
