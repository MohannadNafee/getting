import Foundation
import CoreLocation

class PlaceOfInterest {
    var id: String
    var name: String
    var rating: Double?
    var formattedAddress: String?
    var iconUrl: String?
    var image_ref: String?
    var latitude: Double?
    var longitude: Double?
    var place_id: String?
    var location: CLLocation?
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String else {
            return nil
        }
        guard let name = json["name"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
        
        if let value = json["rating"] as? Double {
            self.rating = value
        } else {
            self.rating = 0
        }
        self.formattedAddress = json["formatted_address"] as? String
        self.iconUrl = json["icon"] as? String
        

        self.place_id = json["place_id"] as? String
        let geo_details = json["geometry"] as? [String:AnyObject]
        let location = geo_details!["location"] as? [String:Double]
        self.latitude = location!["lat"]
        self.longitude = location!["lng"]
        if let  image = json["photos"] as? [[String: Any]] {
            self.image_ref = image[0]["photo_reference"] as? String
        }
        if let geometry = json["geometry"] as? [String: Any] {
            if let locationCoordinate = geometry["location"] as? [String: Double
                ] {
                if locationCoordinate["lat"] != nil, locationCoordinate["lng"] != nil {
                    self.location = CLLocation(latitude: locationCoordinate["lat"]!, longitude: locationCoordinate["lng"]!)
                }
            }
        }

    }
}
