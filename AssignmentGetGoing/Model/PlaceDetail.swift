import UIKit

class PlaceDetail: NSObject {
    var phone: String?
    var website: String?
    
    init?(json: [String: Any]){
        self.phone = json["formatted_phone_number"] as? String
        self.website = json["website"] as? String
    }
}
