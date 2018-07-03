import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var places: [PlaceOfInterest]!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tableViewCellNib = UINib(nibName: "POITableViewCell", bundle: nil)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: "resuableIdentifier")
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    // MARK: - TableView Deligate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func sortSgChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            places = places.sorted {
                $0.name < $1.name
            }
            tableView.reloadData()
            break;
        default:
            places = places.sorted {
                $0.rating! < $1.rating!
            }
            tableView.reloadData()
            break;
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resuableIdentifier") as!
        POITableViewCell
        
        cell.titleLabel.text = places[indexPath.row].name
        cell.addressLabel.text = places[indexPath.row].formattedAddress
        cell.ratingLabel.text = "\(places[indexPath.row].rating ?? 0)"
        if let imageUrl = places[indexPath.row].iconUrl, let url = URL(string: imageUrl), let dataContents = try? Data(contentsOf: url), let imageSrc = UIImage(data: dataContents) {
            cell.iconImageView.image = imageSrc
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.place = places[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }


}
