//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Nikhil  Agrawal on 6/27/20.
//  Copyright © 2020 Nikhil Agrawal. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var imageLabel: UIImageView!
    var pokemon: Pokemon!
    @IBOutlet var imageLoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type1Label.text = ""
        type2Label.text = ""
        imageLoadingIndicator.isHidden = false
        loadData(fromURL: pokemon.url)
        catchButtonTitle()
    }
    
    func loadData(fromURL url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                guard let imageUrl = URL(string: pokemonData.sprites.front_default) else { return }
                let data = try Data(contentsOf: imageUrl)
                DispatchQueue.main.async {
                    self.nameLabel.text = self.pokemon.name.capitalizingFirstLetter()
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    self.imageLoadingIndicator.isHidden = true
                    self.imageLabel.image = UIImage(data: data)
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name.capitalizingFirstLetter()
                        } else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name.capitalizingFirstLetter()
                        }
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    @IBAction func toggleCatch(_ sender: UIButton) {
        UserDefaults.standard.set(!pokemon.isCatched, forKey: pokemon.name)
        catchButtonTitle()
    }
    
    func catchButtonTitle() {
        let curTitle = pokemon.isCatched ? "Release" : "Catch"
        catchButton.setTitle(curTitle, for: .normal)
    }
}

extension UserDefaults {
    static func contains(_ key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
