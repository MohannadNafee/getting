import Foundation

class APIParser {
    
    class func parseDetailsValue(json: [String: Any]) -> PlaceDetail?{
        
        if let result = json["result"] as? [String:Any] {
            
            if let value = PlaceDetail(json: result){
                return value
            }
            
        }
        return nil
    }
    
    class func parserAPIResponse(json: [String: Any]) -> [PlaceOfInterest] {
        var places: [PlaceOfInterest] = []
        if let results = json["results"] as? [[String: Any]] {
            for result in results {
                if let newPlace = PlaceOfInterest(json: result) {
                    places.append(newPlace)
                }
            }
        }
        return places
    }
}
