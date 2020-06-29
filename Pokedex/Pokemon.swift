//
//  Pokemon.swift
//  Pokedex
//
//  Created by Nikhil  Agrawal on 6/14/20.
//  Copyright © 2020 Nikhil Agrawal. All rights reserved.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
    var isCatched: Bool {
        if !UserDefaults.contains(name) {
            UserDefaults.standard.set(false, forKey: name)
        }
        return UserDefaults.standard.bool(forKey: name)
    }

    private enum CodingKeys: String, CodingKey {
        case name, url
    }
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: PokemonImage
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonImage: Codable {
    let front_default: String
}
