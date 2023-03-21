import SwiftUI

struct NorCalMotocrossView: View {
    let event: NorCalMotocross
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.event) 
            Text(event.date) 
                .foregroundColor(.gray)  
                .font(.caption)
        }
    }
}
