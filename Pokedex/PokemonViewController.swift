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
    @IBOutlet var descriptionLabel: UITextView!
    
    @IBOutlet weak var descriptionLoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type1Label.text = ""
        type2Label.text = ""
        imageLoadingIndicator.isHidden = false
        descriptionLoadingIndicator.isHidden = false
        loadPokemonData(fromURL: pokemon.url)
        catchButtonTitle()
    }
    
    func loadPokemonData(fromURL url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemonData = try decoder.decode(PokemonData.self, from: data)
                self.loadPokemonDescription(fromURL: "https://pokeapi.co/api/v2/pokemon-species/\(pokemonData.id)/")
                guard let imageUrl = URL(string: pokemonData.sprites.frontDefault) else { return }
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
    
    func loadPokemonDescription(fromURL url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemonDescription = try decoder.decode(PokemonDescription.self, from: data)
                let pokemonEnglishDescriptionList = pokemonDescription.flavorTextEntries.filter { $0.language.name == "en" }
                
                DispatchQueue.main.async {
                    if !pokemonEnglishDescriptionList.isEmpty {
                        self.descriptionLoadingIndicator.isHidden = true
                        self.descriptionLabel.text = pokemonEnglishDescriptionList[0].flavorText.removeSpace()
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

extension String {
    func removeSpace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines).joined(separator: " ")
    }
}
