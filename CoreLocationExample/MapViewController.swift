//
//  MapViewController.swift
//  CoreLocationExample
//
//  Created by Andrew Bailey on 11/28/18.
//  Copyright © 2018 Andrew Bailey. All rights reserved.
//

let ClientID                = "RAGVBCWW14FXLMWOYWCPUIGM4BEGUMGPMT1EUZG5MVTFQMTD"
let ClientSecret            = "EXFZSJWZK0KODJZHUMK3EXEPTFQ3U4OWX1JPIJNFEN20X0II"
let FOURSQUARE_URL_FORMAT   = "https://api.foursquare.com/v2/venues/search?near=%@&query=%@&client_id=%@&client_secret=%@&v=20130815"

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var appleMap: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 30 // in meters
        
//        var location1 = CLLocation.init(latitude: , longitude)
//        var location2 = CLLocation.init(latitude: , longitude)
//        var location3 = CLLocation.init(latitude: , longitude)
    }
    
    func createAnnotation(location: CLLocation, title: String)
    {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        pin.title = title
        appleMap.addAnnotation(pin)
        appleMap.showAnnotations(appleMap.annotations, animated: true)
        //setupZoom(location: location)
    }
    
    func setupZoom(location: CLLocation)
    {
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        appleMap.setRegion(region, animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: Any)
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            print("Does this win out?")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locationManager.location?.coordinate.latitude)
        print(locationManager.location?.coordinate.longitude)
        
        /*print(locations.count)
        if let location = locations.last {
            //getCurrentCity(location: location)
            //createAnnotation(location: location, title: "Current Location")
            //locationManager.stopUpdatingLocation()
            localSearchAPI(location: location)
            
            print(location)
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        } // */
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
    
    func localSearchAPI(location: CLLocation)
    {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Hotel"
        request.region = appleMap.region
        let search = MKLocalSearch(request: request)
        search.start()
        {
            (response, error) in
            if let response = response {
                //print(response.mapItems)
                for item in response.mapItems {
                    let pin = MKPointAnnotation()
                    pin.coordinate = item.placemark.coordinate
                    pin.title = item.placemark.locality ?? "test"
                    self.appleMap.addAnnotation(pin)
                }
                self.appleMap.showAnnotations(self.appleMap.annotations, animated: true)
            }
        }
    }
    
//    func getCurrentCity(location: CLLocation)
//    {
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location)
//        {
//            (placemarks, error) in
//            if let placemark = placemarks?.last {
//                guard let locality = placemark.locality, let country = placemark.country else {
//                    return
//                }
//                let url = self.getURLString(format: FOURSQUARE_URL_FORMAT, searchLocation: locality, searchCriteria: "Food")
//                print(url)
//                print("\(locality), \(country)")
//            }
//        }
//    }
    
//    func getPlacemarkFromLocality(locality: String)
//    {
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(locality)
//        {
//            (placemarks, error) in
//            if let placemark = placemarks?.last {
//                print(placemark.location?.coordinate)
//            }
//        }
//    }
    
    private func getURLString(format: String, searchLocation: String, searchCriteria: String) -> String
    {
        return String(format: format, searchLocation, searchCriteria, ClientID, ClientSecret)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }

        let annotationIdentifier = "customAnnotationView"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true // ???
        } else {
            annotationView?.annotation = annotation
        } // */

        let pinImage = UIImage(named: "customPin")
        annotationView?.image = pinImage

        return annotationView
    }
}
