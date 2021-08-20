//
//  User Preferences.swift
//  News
//
//  Created by user198890 on 8/4/21.
//

import UIKit

let countries = [
    "Argentina",
    "Australia",
    "Austria",
    "Belgium",
    "Brazil",
    "Bulgaria",
    "Canada",
    "China",
    "Colombia",
    "Cuba",
    "Egypt",
    "France",
    "Germany",
    "Greece",
    "Hungary",
    "India",
    "Indonesia",
    "Ireland",
    "Israel",
    "Italy",
    "Japan",
    "Netherlands (the)",
    "New Zealand",
    "Russian Federation (the)",
    "Saudi Arabia",
    "Singapore",
    "South Africa",
    "Switzerland",
    "Taiwan",
    "Turkey",
    "United States of America (the)",
    "Venezuela (Bolivarian Republic of)"
]

let categories = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology"
]

// View controller for setting user's prefered news sources
class UserPreferencesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var categoryPicker: UIPickerView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        
        // if country is saved in user defaults, set selected to that country
        if let country = UserDefaults.standard.string(forKey: "country") {
            countryPicker.selectRow(countries.lastIndex(of: country)!, inComponent: 0, animated: true)
        }
        
        // if category is saved in user defaults, set selected to that category
        if let category = UserDefaults.standard.string(forKey: "category") {
            categoryPicker.selectRow(categories.lastIndex(of: category)!, inComponent: 0, animated: true)
        }
        
        // create title label for nav bar
        let titleLabel = UILabel()
        titleLabel.text = "News"
        let titleView = UIStackView(arrangedSubviews: [titleLabel])
        titleView.axis = .vertical
        titleView.alignment = .center
        navigationItem.titleView = titleView
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPicker { return countries.count }
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPicker {
            return countries[row]
        } else if pickerView == categoryPicker {
            return categories[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaults = UserDefaults.standard
        
        if pickerView == countryPicker {
            defaults.set(countries[row], forKey: "country")
        } else if pickerView == categoryPicker {
            defaults.set(categories[row], forKey: "category")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
