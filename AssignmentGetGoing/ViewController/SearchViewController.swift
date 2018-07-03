import UIKit
import CoreLocation

extension SearchViewController: LocationServiceDelegate, FilterVCDelegate {
    
    func tracingLocation(_ currentLocation: CLLocation) {
        current_location = currentLocation
        print("\(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)")
    }
    
    func tracingLocationDidFailWithError(_ error: Error) {
        
    }
    func getUpdatedQueryItems(rankBy: String, distance: String, openNow: Bool) {
        self.rankBy = rankBy
        self.radius = distance
        self.isOpen = openNow
    }
}

class SearchViewController: UIViewController {
    var searchParam: String?
    
    
    
    @IBOutlet weak var sg: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchParameterTextField.delegate = self
    }
    

    @IBOutlet weak var searchParameterTextField: UITextField!
    
    //MARK: Search Button Action
    
    var rankBy = "Prominence"
    var radius = "25000"
    var isOpen = false
    var current_location: CLLocation?
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        print("choo choo choo button")
        searchParameterTextField.resignFirstResponder()
        
        
        if sg.selectedSegmentIndex == 0 {
            if let inputValue = searchParam {
                GooglePlacesAPI.textSearch(query: inputValue, rank: rankBy, distance: radius, openNow: isOpen, completionHandler: {(status, json) in
                    if let jsonObj = json {
                        let places = APIParser.parserAPIResponse(json: jsonObj)
                        DispatchQueue.main.async {
                            if places.count > 0 {
                                self.presentSearchResults(places)
                            } else {
                                self.generalAlert("Oops", "No results found")
                            }
                        }
                    } else {
                        self.generalAlert("Oops", "An errorparsing json")
                    }
                })
            } else {
                
                generalAlert("Something wrong", "An error has occurred")
            }
        }
        else {
            guard let latitude = current_location?.coordinate.latitude , let longitude = current_location?.coordinate.longitude  else { return }
            
            
                GooglePlacesAPI.locationSearch(lat: latitude, lng: longitude, rank: rankBy, distance: radius, openNow: isOpen, completionHandler: {(status, json) in
                    if let jsonObj = json {
                        let places = APIParser.parserAPIResponse(json: jsonObj)
                        DispatchQueue.main.async {
                            if places.count > 0 {
                                self.presentSearchResults(places)
                            } else {
                                self.generalAlert("Something wrong", "No results found")
                            }
                        }
                    } else {
                        self.generalAlert("Something Wrong", "An errorparsing json")
                    }
                })
            }
        

        
    }
    
    func presentSearchResults(_ results: [PlaceOfInterest]) {
        let searchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsViewController.places = results
        
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
    
    @IBAction func sgChanged(_ sender: UISegmentedControl) {
        if sg.selectedSegmentIndex == 1 {
            LocationService.sharedInstance.delegate = self
            LocationService.sharedInstance.startUpdatingLocation()
        }
    }
    
    func generalAlert(_ title: String,_ message: String?) {
        let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(action)
            in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true) {
            self.searchParameterTextField.placeholder = "Input Something"
        }
    }
    
    @IBAction func filter_Action(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    

    
}
// MARK: Text Field Delegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchParameterTextField {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == searchParameterTextField {
            searchParam = textField.text
            print("Hello world ", textField.text ?? "no input")
        }
        return true
    }
    
}


