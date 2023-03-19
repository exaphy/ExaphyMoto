import SwiftSoup
import SwiftUI

class DataServiceMotoLive: ObservableObject {
    var images = [String]()
    let url = URL(string: "https://www.swapmotolive.com/cmxrs-race-schedule/")
    
    func fetchImages() {
        if let url = url {
            do {
                let stringURL = try String(contentsOf: url)
                let document = try SwiftSoup.parse(stringURL)
                let image = try document.getElementsByAttribute("src")
                let sortedImages = try image.array().map { try $0.attr("src").description }
                 images = sortedImages.filter { $0.contains("SMRS")}
            } catch {
                print("An error has occured in DataServiceMotoLive, fetchImages: \(error)")
            }
        }
    }
}
