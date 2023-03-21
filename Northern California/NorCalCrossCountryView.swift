import SwiftUI

struct NorCalCrossCountryView: View {
    let event: NorCalCrossCountry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.event) 
            Text(event.date) 
                .foregroundColor(.gray)  
                .font(.caption)
        }
    }
}

