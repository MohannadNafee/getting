import Foundation
import UIKit

class Constants {
    static let apiKey = "AIzaSyA-e97lcy1hvjOQDV0sX7PExEqVES_n6BY"
    static let scheme = "https"
    static let host = "maps.googleapis.com"
    static let textPlaceSearch = "/maps/api/place/textsearch/json"
    static let photoPath = "/maps/api/place/photo"
    static let detailsPath = "formatted_phone_number,website"
    
    class func getUrl(photoReference: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.photoPath
        
        urlComponents.queryItems = [
            URLQueryItem(name: "maxwidth", value: "500"),
            URLQueryItem(name: "photoreference", value: photoReference),
            URLQueryItem(name: "key", value: Constants.apiKey)
            
        ]
        return urlComponents.url!
    }
} 



extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
