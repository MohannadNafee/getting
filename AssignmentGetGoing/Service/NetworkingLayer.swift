
import Foundation

class NetworkingLayer {
    class func getRequest(with urlComponents: URLComponents,
                          timeoutInterval: TimeInterval = 240.0,
                          completion: @escaping(_ statusCode: Int, _ data: Data?) -> Void) {
        
        let session = URLSession.shared
        
        if let url = urlComponents.url {
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
           
            
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response,error)
                in
                if error != nil {
                    if error?._code == NSURLErrorTimedOut {
                        completion(408, nil)
                    } else {
                        completion(error?._code ?? 500,nil)
                    }
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    completion(httpResponse?.statusCode ?? 500, data)
                }
                
            }
            dataTask.resume()
        }
    
    }
}
