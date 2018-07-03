
import UIKit

class FilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
    }
    var delegate: FilterVCDelegate?
    
    @IBAction func applyAction(_ sender: Any) {
        delegate?.getUpdatedQueryItems(rankBy: rankBy, distance: radius, openNow: openSwitch.isOn)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var rankBy = "Prominence"
    var radius = "25000"
    
    @IBOutlet weak var openSwitch: UISwitch!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func ranksliderChanged(_ sender: UISlider) {
        radius = "\(Int(ceil(sender.value * 50000)))"
    }
    
    let ranks = ["Prominence", "Distance"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ranks.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ranks[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rankBy = ranks[row]
    }
    
    
}
protocol FilterVCDelegate {
    func getUpdatedQueryItems(rankBy: String,distance: String, openNow: Bool)
}
