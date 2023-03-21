import SwiftUI

struct ContentView: View {
    @StateObject var dataNGPC = DataServiceNGPCMain()
    @StateObject var dataNGPCDetail = DataServiceNGPCDetail()
    @StateObject var dataMoto = DataServiceMotoLive()
    @StateObject var dataNational = DataServiceNationalMain()
    @StateObject var dataNationalDetail = DataServiceNationalDetail()
    @StateObject var dataSoCal = DataServiceSoCalMain()
    @StateObject var dataMXTrack = DataServiceMXTrack() 
    @StateObject var dataMXTrackDetail = DataServiceMXTrackDetail()
    @StateObject var dataNorCal = DataServiceNorCalMain()
    @StateObject var dataNorCalDetail = DataServiceNorCalDetail() 
    @State var isLoading = true
    
    var body: some View {
        if isLoading {
            WelcomeScreen()
                .onAppear {
                    DispatchQueue.global(qos: .userInteractive).async {
                      //  dataNGPC.fetchEvents()
                      //  dataNGPCDetail.fetchURLs()
                     //   dataNGPCDetail.fetchDetails()
                      //  dataMoto.fetchImages()
                    //    dataNational.fetchEvents()
                     //   dataNationalDetail.fetchURLs()
                     //   dataNationalDetail.fetchDetails()
                    //    dataSoCal.fetchEvents()
                   //     dataMXTrack.fetchTracks()
                    //    dataMXTrackDetail.fetchURLs()
                   //     dataMXTrackDetail.fetchDetails()
                        dataNorCal.fetchMotocross() 
                        dataNorCal.fetchCrossCountry()
                        dataNorCalDetail.fetchMotocrossURLs() 
                        dataNorCalDetail.fetchCrossCountryURLs()
                        dataNorCalDetail.getMotocrossDetails()
                        dataNorCalDetail.getCrossCountryDetails()
                        DispatchQueue.main.async {
                            isLoading = false
                        }
                    }
                }
        } else {
            TabView {
            NGPCView(data: dataNGPC, dataDetail: dataNGPCDetail)
                    .tabItem {
                        Label("NGPC", systemImage: "person")
                    }
                    
                MotoLiveView(data: dataMoto)
                    .tabItem {
                        Label("Swap Moto", systemImage: "person")
                    }
                    
                NationalMainView(data: dataNational, dataDetail: dataNationalDetail)
                    .tabItem {
                        Label("National Hare", systemImage: "person")
                    }
                    
                SoCalMXView(data: dataSoCal)
                    .tabItem {
                        Label("SoCal MX", systemImage: "person")
                    }
                    
                MXTrackMainView(data: dataMXTrack, dataDetail: dataMXTrackDetail)
                    .tabItem {
                        Label("MX Tracks", systemImage: "person")
                    }
                
                NorCalMainView(data: dataNorCal, dataDetail: dataNorCalDetail) 
                    .tabItem {
                        Label("NorCal MX", systemImage: "person")
                    }
            }
        }
    }
}

