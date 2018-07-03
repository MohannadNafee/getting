import UIKit
import MapKit

class DetailsViewController: UIViewController {

    var place: PlaceOfInterest!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       initComponents()
        setMapViewCoordinate()
    }
    func initComponents() {
        self.title = place.name
        formattedAddressLabel.text = place.formattedAddress
        if let value = place?.image_ref {
            imageview.downloadedFrom(url: Constants.getUrl(photoReference: value))
        }
        
        
        guard let place = self.place else { return }
        if let placeId = place.place_id {
            GooglePlacesAPI.requestDetails(placeId: placeId, completionHandler: {(status, json) in
                if let jsonObj = json {
                    if let value = APIParser.parseDetailsValue(json: jsonObj) {
                        if let phone = value.phone, let website = value.website {
                            self.formattedAddressLabel.text = "\(String(describing: place.formattedAddress ?? ""))\n\(phone)\n\(website)"
                        }
                    }
                }
            })
        }
    }

    @IBOutlet weak var formattedAddressLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    func setMapViewCoordinate(){
        mapView.delegate = self
        if let coordinate = place?.location?.coordinate {
            let annotation = MKPointAnnotation()
            annotation.title = place?.name
            annotation.coordinate.latitude = coordinate.latitude
            annotation.coordinate.longitude =  coordinate.longitude
            mapView.addAnnotation(annotation)
            centerMapOnLocation(annotation.coordinate)
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let radius = 5000
        let region = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(Double(radius) * 2.0), CLLocationDistance(Double(radius) * 2.0))
        mapView.setRegion(region, animated: true)
    }


}

extension DetailsViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusePin")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        view.pinTintColor = UIColor.blue
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        if let coordinate = view.annotation?.coordinate {
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.openInMaps(launchOptions: launchingOptions)
        }
    }
}

