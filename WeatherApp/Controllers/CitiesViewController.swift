//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Anastasiia on 01.08.2021.
//

import UIKit
import MapKit

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    
    
    @IBOutlet weak var addedCitiesTableView: UITableView!
    let cellID = "cellID"
    
    public var addedCities : [OneCallObject]? = Array<OneCallObject>()
    
    let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addedCitiesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        addedCitiesTableView.delegate = self
        addedCitiesTableView.dataSource = self
        
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
    }
 
    @IBAction func EditCities_Clicked(_ sender: UIBarButtonItem) {
        addedCitiesTableView.isEditing = !addedCitiesTableView.isEditing
        EditButton.title = addedCitiesTableView.isEditing ? "Done" : "Edit"
    }
}



//MARK: - extension for TableView
extension CitiesViewController : UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = addedCitiesTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            
        if self.addedCities!.count > 0 && indexPath.row < self.addedCities!.count {
            cell.textLabel?.text  = self.addedCities?[indexPath.item].timezone
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let modelLat = String(format: "%.4f", self.addedCities?[indexPath.item].lat ?? 0.0)
        let modelLon = String(format: "%.4f", self.addedCities?[indexPath.item].lon ?? 0.0)
        
        NetworkManager.shared.deleteCity(lat: modelLat, lon: modelLon){ [weak self] object in
            self?.addedCities?.remove(at: indexPath.item)
        }
        addedCitiesTableView.reloadData()
    }
}

//MARK: - extension for Searcher
extension CitiesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }

        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    print(places)
                    resultsVC.update(with: places)
                    resultsVC.cities = self.addedCities
                    resultsVC.searchVC = self.searchVC
                    self.addedCitiesTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }

        }
    }
}
