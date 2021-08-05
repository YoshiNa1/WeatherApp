//
//  SearchResultsViewController.swift
//  WeatherApp
//
//  Created by Anastasiia on 03.08.2021.
//

import UIKit

class SearchResultsViewController: UIViewController {

    public var cities : [OneCallObject]? = Array<OneCallObject>()
    private var model: Json4Swift_Base?
    private var places: [Place] = []
    
    var searchVC = UISearchController()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: 320)
        
    }
    public func update(with places: [Place]) {
        self.places = places
        tableView.reloadData()
    }
    
    func addCity(lat: String, lon: String) {
        let lat = lat
        let lon = lon
        NetworkManager.shared.getOneCallObjectCall(lat: lat, lon: lon) { [weak self] object in
           DispatchQueue.main.async {
                self?.cities?.append(object!)
               
//                 print(self?.cities?.count as Any)
//                 print(self?.cities as Any)
            }
        }
    }
    
    
}
//MARK: -- tableView extension
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkManager.shared.getCityCoordinates(name: places[indexPath.row].name) { [weak self] object in
            self?.model = object
            DispatchQueue.main.async {
                let lat = self?.model?.candidates?[0].geometry?.location?.lat
                let lon = self?.model?.candidates?[0].geometry?.location?.lng
                self?.addCity(lat: String(format: "%.4f", lat ?? 0.0), lon: String(format: "%.4f", lon ?? 0.0))
            }
            self?.searchVC.searchBar.showsCancelButton = false
            self?.searchVC.searchBar.text = nil
            self?.searchVC.searchBar.resignFirstResponder()
            tableView.reloadData()
        }
    }
    
}
