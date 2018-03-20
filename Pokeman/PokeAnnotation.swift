//
//  PokeAnnotation.swift
//  Pokeman
//
//  Created by William Hettinger on 3/20/18.
//  Copyright © 2018 William Hettinger. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
