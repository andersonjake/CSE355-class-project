//
//  MapViewController.swift
//  class-project
//
//  Created by Jake Anderson on 11/15/18.
//  Copyright © 2018 Jake Anderson. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var map: MKMapView!
    var searchActive : Bool = false
    
    var manager:CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //userLocation - there is no need for casting, because we are now using CLLocation object
        
        let userLocation:CLLocation = locations[0]
        self.showCurrentLocation(location: userLocation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search(querey: self.searchBar.text!)
    }
    
    func search(querey: String){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = querey
        request.region = map.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            print( response.mapItems )
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            self.showOnMap(matchingItems: matchingItems)
        }
    }
    
    func showCurrentLocation(location: CLLocation){
        let geoCoder = CLGeocoder()
        // Geocode Location
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let location = placemark.location
                let coords = location!.coordinate
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                self.map.setRegion(region, animated: true)

            }
        }
    }
    
    
    func showOnMap(matchingItems: [MKMapItem]){
        
        for i in 1...matchingItems.count - 1{
            let place = matchingItems[i].placemark
            let lat = Double((place.location?.coordinate.latitude)!)
            let long = Double((place.location?.coordinate.longitude)!)
            let location = CLLocation(latitude: lat, longitude: long)
            
            let geoCoder = CLGeocoder()
            // Geocode Location
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    print("=====================================================")
                    print(place)
                    print("=====================================================")
                    let location = placemark.location
                    let coords = location!.coordinate
                    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                    self.map.setRegion(region, animated: true)
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = place.name
                    ani.subtitle = placemark.locality
                    self.map.addAnnotation(ani)
                    
                }
            }
        }
        
    }
    
}
