//
//  ViewController.swift
//  Explore
//
//  Created by Hao Mou on 04/11/2017.
//  Copyright © 2017 Icosahedron. All rights reserved.
//

import UIKit
import CoreLocation

// Some parameters we can tweak
let maxDist = 1000.0
let minDist = 25.0
let accuracy = 15.0
let rOfRndmPoint = 0.0015

var (startLong, startLat) : (Double, Double) = (0.0, 0.0)
var (newLat, newLong) : (Double, Double) = (0.0, 0.0)
var (latitude, longitude) : (Double, Double) = (0.0, 0.0)
var counter = 0
var active = 0

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var distInd: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var solution: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var myLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        myLocation = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewWillAppear() {
        repeat {
            (newLat, newLong) = random_location(latitude, longitude, rOfRndmPoint, rOfRndmPoint)
        } while compute_distance(startLat, startLong, newLat, newLong) > maxDist || compute_distance(startLat, startLong, newLat, newLong) < minDist
        location.text = String(format: "%.5f", newLat) + ", " + String(format: "%.5f", newLong)
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: newLat, longitude: newLong))
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        latitude = latestLocation.coordinate.latitude
        longitude = latestLocation.coordinate.longitude
        
        location.text = "Your location: (" + String(format: "%.5f", latitude) + ", " + String(format: "%.5f", longitude) + ")"
        
        if counter == 0 {
            (startLong, startLat) = (longitude, latitude)
            counter += 1
        }
        
        let distance = compute_distance(destLat, destLong, latitude, longitude)
        
        if active > 0 {
            if distance > 15 {
                distInd.textColor = UIColor.lightGray
                distInd.text = String(Int(floor(distance / 10)) * 10) + " meters away"
                if distance <= 100 {
                    progress.progress = 1 - Float(distance) / 100.0
                } else {
                    progress.progress = 0
                }
            } else {
                distInd.textColor = UIColor.black
                distInd.text = "You Win!"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
    }
 
    
    @IBAction func generate(_ sender: UIButton) {
        repeat {
            (newLat, newLong) = random_location(latitude, longitude, rOfRndmPoint, rOfRndmPoint)
        } while compute_distance(startLat, startLong, newLat, newLong) > maxDist || compute_distance(startLat, startLong, newLat, newLong) < minDist
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: newLat, longitude: newLong))
        active = 1
    }
    

}

