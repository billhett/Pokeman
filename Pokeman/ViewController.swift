//
//  ViewController.swift
//  Pokeman
//
//  Created by William Hettinger on 3/16/18.
//  Copyright © 2018 William Hettinger. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var updateCount = 0
    var manager = CLLocationManager()
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Ready to go!")
            mapView.delegate = self
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                //spawn Pokemon every 5 seconds
                print("timer")
                
                if let coord = self.manager.location?.coordinate {
                    let anno = MKPointAnnotation()
                    //let region = MKCoordinateRegionMakeWithDistance(coord, 200,200)
                    //self.mapView.setRegion(region, animated: true)
                    anno.coordinate = coord
                    let randoLat = (Double(arc4random_uniform(200))-100)/50000.0
                    let randoLon = (Double(arc4random_uniform(200)) - 100)/50000
                    anno.coordinate.latitude += randoLat
                    anno.coordinate.longitude += randoLon
                    self.mapView.addAnnotation(anno)
                }
                
            })
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            
            //return nil   does blue dot
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "122-player")
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
            return annoView
        }
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annoView.image = UIImage(named: "112-mew")
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        return annoView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("We made it")
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance((manager.location?.coordinate)!, 400,400)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 400,400)
            mapView.setRegion(region, animated: true)
        }
    }
    
}

