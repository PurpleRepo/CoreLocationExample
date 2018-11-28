//
//  MapViewController.swift
//  CoreLocationExample
//
//  Created by Andrew Bailey on 11/28/18.
//  Copyright © 2018 Andrew Bailey. All rights reserved.
//

let ClientID                = "RAGVBCWW14FXLMWOYWCPUIGM4BEGUMGPMT1EUZG5MVTFQMTD"
let ClientSecret            = "EXFZSJWZK0KODJZHUMK3EXEPTFQ3U4OWX1JPIJNFEN20X0II"
let FOURSQUARE_URL_FORMAT   = "https://api.foursquare.com/v2/venues/search?near=%@&location&query=%@&client_id=%@&client_secret=%@&v=20130815"

import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 30 // in meters
    }
    
    @IBAction func startButtonPressed(_ sender: Any)
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            getCurrentCity(location: location)
            locationManager.stopUpdatingLocation()
            
            print(location)
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getCurrentCity(location: CLLocation)
    {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) in
            if let placemark = placemarks?.last {
                guard let locality = placemark.locality, let country = placemark.country else {
                    return
                }
                print("\(locality), \(country)")
            }
        }
    }
    
    private func getURLString(format: String, searchLocation: String, searchCriteria: String) -> String {
        return String(format: format, searchLocation, searchCriteria, ClientID, ClientSecret)
    }
}
