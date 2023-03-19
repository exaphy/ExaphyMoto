import SwiftUI

struct MotoLiveView: View {
    @ObservedObject var data: DataServiceMotoLive
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(data.images, id: \.self) {
                    AsyncImage(url: URL(string: $0)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("Swap Moto Live")
        }
    }
}
