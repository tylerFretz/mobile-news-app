//
//  MapViewController.swift
//  News
//
//  Created by user198890 on 8/5/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        MapView.addGestureRecognizer(gestureRecognizer)
        
        let country = UserDefaults.standard.string(forKey: "country") ?? ""
        let category = UserDefaults.standard.string(forKey: "category") ?? ""
        let titleLabel = UILabel()
        titleLabel.text = "News"
        subtitleLabel.text = "\(country) - \(category)"
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        let titleView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleView.axis = .vertical
        titleView.alignment = .center
        navigationItem.titleView = titleView
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: MapView)
        let coordinate = MapView.convert(location, toCoordinateFrom: MapView)
        
        let clLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(clLocation) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to reserse geocode location \(error)")
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                
                if let country = placemark.getCountry {
                    showCountryChangeAlert(country: country)
                }

            }
        }
    }
    
    func showCountryChangeAlert(country: String?) {
        let alert = UIAlertController(title: "Change country", message: "Set country to \(country ?? "")?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let defaults = UserDefaults.standard
            defaults.set(country, forKey: "country")
            let category = UserDefaults.standard.string(forKey: "category") ?? ""
            self.subtitleLabel.text = "\(country ?? "") - \(category)"

        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
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

// extension to CLPlacemark class to return only country name
extension CLPlacemark {
    var getCountry: String? {
        if let country = country {
            return country
        }
        return nil
    }
}
