//
//  MapViewController.swift
//  class-project
//
//  Created by Jake Anderson on 11/15/18.
//  Copyright © 2018 Jake Anderson. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var map: MKMapView!
    var searchActive : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search()
    }
    
    func search(){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.searchBar.text!
        request.region = map.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            print( response.mapItems )
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            let place = matchingItems[0].placemark
            let lat = place.location?.coordinate.latitude
            let long = place.location?.coordinate.longitude
            self.showOnMap(lati: Double(lat!), longi: Double(long!))
        }
    }
    
 

    func showOnMap(lati: Double , longi: Double){
        let location = CLLocation(latitude: lati, longitude: longi)
        
        // Geocode Location
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    let coords = location!.coordinate
                    print(location)
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                    self.map.setRegion(region, animated: true)
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = placemark.locality
                    ani.subtitle = placemark.subLocality
                    
                    self.map.addAnnotation(ani)
                    
                    
                }
        }
        
    }
    
}
