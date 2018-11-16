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
    var currentLocation=CLLocation();
    var userPlacemark=MKPlacemark();
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoute: MKRoute?

    var manager:CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        map.delegate = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.map.showsUserLocation = true
        if #available(iOS 9.0, *) {
            self.map.showsCompass = true
            self.map.showsScale = true
            self.map.showsTraffic = true
        }
        
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
        let userLocation:CLLocation = locations[0]
        self.currentLocation = userLocation;
        let span = MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)
        let region = MKCoordinateRegion(center: self.currentLocation.coordinate, span: span)
        self.map.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search(querey: self.searchBar.text!)
    }
    
    func search(querey: String){
        self.map.removeAnnotations(self.map.annotations)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = querey
        request.region = map.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            self.showOnMap(matchingItems: matchingItems)
        }
    }
    
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool){
            self.search(querey: "book store")
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
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = place.name
                    ani.subtitle = String(placemark.location!.distance(from: self.currentLocation))
                    self.map.addAnnotation(ani)
                    
                }
            }
        }
        
    }
    func getPlacemark(location: CLLocation) -> MKPlacemark{
        let geoCoder = CLGeocoder()
        // Geocode Location
        var placemark = MKPlacemark()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
//                placemark = placemarks![0]
                let coordinate = placemarks![0].location!.coordinate
                placemark = MKPlacemark(coordinate: coordinate)
            }
        }
        return placemark
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let place = MKPlacemark(coordinate: (view.annotation?.coordinate)!)
        self.showDirections(place: place)
    }
    
    func showDirections(place: MKPlacemark)
    {
        
        let x: CLLocationCoordinate2D = self.currentLocation.coordinate
        let userPlacemark = MKPlacemark(coordinate: x)
        // get the directions
        let directionRequest = MKDirections.Request()
        
        // Set the source and destination of the route
        let sourcePM = MKPlacemark(placemark: userPlacemark)
        directionRequest.source = MKMapItem(placemark: sourcePM)
        
        //directionRequest.source = MKMapItem.forCurrentLocation()
        
        let destinationPM = MKPlacemark(placemark: place)
        directionRequest.destination = MKMapItem(placemark: destinationPM)
        
        directionRequest.transportType = currentTransportType
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (routeResponse, routeError) -> Void in
            
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }
                
                return
            }
            
            let route = routeResponse.routes[0]
            print("Printing route")
            for step in route.steps {
                print(step.instructions)
            }
            
            
            self.currentRoute = route
            self.map.removeOverlays(self.map.overlays)
            self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            let big = MKMapRect(x: rect.minX - 2000, y: rect.minY - 2000, width: rect.width + 4000 , height: rect.height + 4000)
            self.map.setRegion(MKCoordinateRegion(big), animated: true)
        }
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor.blue : UIColor.orange
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
