//
//  CoreDataHelp.swift
//  Pokeman
//
//  Created by William Hettinger on 3/19/18.
//  Copyright © 2018 William Hettinger. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    let pokemon = Pokemon(context: context)
//    pokemon.name = "Mew"
//    pokemon.imageName = "mew"
//    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    createPokemon(name: "Mew", imageName: "112-mew")
    createPokemon(name: "Meowth", imageName: "125-meowth")
    createPokemon(name: "Pikachu", imageName: "051-pikachu-2")
    createPokemon(name: "Weedle", imageName: "091-weedle")
    createPokemon(name: "Mankey", imageName: "103-mankey")
    createPokemon(name: "Pidgey", imageName: "107-pidgey")
    createPokemon(name: "Rattata", imageName: "109-rattata")
    createPokemon(name: "Zubat", imageName: "123-zubat")
    createPokemon(name: "Eevee", imageName: "126-eevee")
    createPokemon(name: "Snorlax", imageName: "132-snorlax")
    
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createPokemon(name: String, imageName: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}
