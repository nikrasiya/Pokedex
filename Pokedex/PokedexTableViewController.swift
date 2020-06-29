//
//  PokedexTableViewController.swift
//  Pokedex
//
//  Created by Nikhil  Agrawal on 6/14/20.
//  Copyright © 2020 Nikhil Agrawal. All rights reserved.
//

import UIKit

class PokedexTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!

    var pokemonsList = [Pokemon]()

    lazy var matchPokemons = pokemonsList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadData(fromURL: "https://pokeapi.co/api/v2/pokemon?limit=151")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            matchPokemons = findPokemonMatch(from: searchText.lowercased())
        }
        tableView.reloadData()
    }

    func findPokemonMatch(from searchText: String) -> [Pokemon] {
        var pokeResult = [Pokemon]()
        for pokemon in pokemonsList {
            if pokemon.name.lowercased().contains(searchText) {
                pokeResult.append(pokemon)
            }
        }
        return pokeResult
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchPokemons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = matchPokemons[indexPath.row].name.capitalizingFirstLetter()
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue", let destination = segue.destination as? PokemonViewController {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                destination.pokemon = matchPokemons[selectedIndex.row]
            }
        }
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
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemonsList = pokemonList.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
}
