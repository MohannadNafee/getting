import Foundation

class GooglePlacesAPI {
    class func textSearch(query: String, rank: String, distance: String, openNow: Bool, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.textPlaceSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        if rank == "Distance" {
            urlComponents.queryItems?.append(URLQueryItem(name: "radius", value: distance))
        }
        if openNow {
            urlComponents.queryItems?.append(URLQueryItem(name: "opennow", value: "true"))
        }
       
        NetworkingLayer.getRequest(with: urlComponents) { (statusCode, data) in
            if let jsonData = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                print(jsonObject ?? "")
                completionHandler(statusCode, jsonObject)
            } else {
                print("error")
                completionHandler(statusCode, nil)
            }
        }
        
    }
    
    class func requestDetails(placeId: String, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = "/maps/api/place/details/json"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "placeid", value: placeId),
            URLQueryItem(name: "fields", value: Constants.detailsPath),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        NetworkingLayer.getRequest(with: urlComponents) { (statusCode, data) in
            if let jsonData = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                
                completionHandler(statusCode, jsonObject)
            } else {
                print("Some error has been occurred")
                completionHandler(statusCode, nil)
            }
        }
        
    }
    class func locationSearch(lat: Double, lng: Double, rank: String, distance: String, openNow: Bool, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = "/maps/api/place/nearbysearch/json"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "location", value: "\(lat),\(lng)"),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        if rank == "Distance" {
            urlComponents.queryItems?.append(URLQueryItem(name: "radius", value: distance))
        } else {
            urlComponents.queryItems?.append(URLQueryItem(name: "radius", value: "1500"))
        }
        if openNow {
            urlComponents.queryItems?.append(URLQueryItem(name: "opennow", value: "true"))
        }
        
        NetworkingLayer.getRequest(with: urlComponents) { (statusCode, data) in
            if let jsonData = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                print(jsonObject ?? "")
                completionHandler(statusCode, jsonObject)
            } else {
                print("error")
                completionHandler(statusCode, nil)
            }
        }
        
    }
}
