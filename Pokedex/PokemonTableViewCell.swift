//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Nikhil  Agrawal on 6/14/20.
//  Copyright © 2020 Nikhil Agrawal. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet var pokeLabel: UILabel!

    func update(pokeText: String) {
        self.pokeLabel.text = pokeText
    }
}
