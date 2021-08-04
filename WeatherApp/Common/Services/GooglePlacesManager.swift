//
//  GooglePlacesManager.swift
//  WeatherApp
//
//  Created by Anastasiia on 03.08.2021.
//

import Foundation
import GooglePlaces

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PlacesError: Error {
        case failedToFind
    }
        
    public func findPlaces(query: String,
                           completion: @escaping (Result<[Place], Error>) -> Void) {

        let filter = GMSAutocompleteFilter()
        filter.type = .geocode

        client.findAutocompletePredictions(fromQuery: query,
                                           filter: filter,
                                           sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }

            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string)
            })
            completion(.success(places))
        }
    }
}

struct Place {
    let name : String
}
