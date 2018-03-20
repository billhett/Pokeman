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
            setup()
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    
    func setup() {
        print("Ready to go!")
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //spawn Pokemon every 5 seconds
            print("timer")
            
            if let coord = self.manager.location?.coordinate {
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
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
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        annoView.image = UIImage(named: pokemon.imageName!)
        print("Spawing a \(pokemon.name!)")
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        if view.annotation is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200,200)
        mapView.setRegion(region, animated: true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate{
                print("annotation tapped")
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                    print("can catch pokemon")
                    let alertVC = UIAlertController(title: "Awesome!", message: "You caught the \(pokemon.name!) - you are a Pokemon Master!.", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                    })
                    alertVC.addAction(OKaction)
                    let PokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSeque", sender: nil)
                        
                        
                    })
                    alertVC.addAction(PokedexAction)
                    self.present(alertVC, animated: true, completion: nil)
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    mapView.removeAnnotation(view.annotation!)
                }else {
                    print("Pokemon is too far away")
                    let alertVC = UIAlertController(title: "Uh-Oh!", message: "You are too far away to catch the \(pokemon.name!) - move closer to it.", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                    })
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
            
        }
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

