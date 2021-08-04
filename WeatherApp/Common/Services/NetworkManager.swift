//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Anastasiia on 28.07.2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum RequestUnitType : String, CaseIterable {
    case unitMetric = "Metric"
    case unitStandart = "Standart"
    case unitImperial = "Imperial"
}

enum RequestLangType : String, CaseIterable  {
    case langEn = "en"
    case langRu = "ru"
    case langUa = "ua"
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let appid = "2f2df2eab9d993845d2aabb0eb58bd0e"
    var baseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    
    let key = "AIzaSyDg45gfASQrTQ22CP57Vfmeuqy6HbnX4nU"
    let googleApiUrl = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
    
    private func buildParameters(lat: String, lon: String) -> [String : String] {
        return [ "lat": lat,
                 "lon": lon,
                 "units": SettingsManager.shared.requestUnit.rawValue,
                 "lang": SettingsManager.shared.requestLanguage.rawValue,
                 "exclude": "hourly,minutely",
                 "appid": appid ]
    }
    
    func getOneCallObjectCall(lat: String, lon: String, unit: RequestUnitType = .unitMetric, lang: RequestLangType = .langEn, completion: @escaping (OneCallObject?) -> Void) {
        
        AF.request(baseUrl, method: .get, parameters: buildParameters(lat: lat, lon: lon)).responseObject {
            (response: DataResponse<OneCallObject, AFError>) in
            if response.error == nil {
                do {
                    let obj = try response.result.get()
                    completion(obj)
                }
                catch {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        }
    }
    
    
    func deleteCity(lat: String, lon: String, unit: RequestUnitType = .unitMetric, lang: RequestLangType = .langEn, completion: @escaping (OneCallObject?) -> Void) {
        
        AF.request(baseUrl, method: .delete, parameters: buildParameters(lat: lat, lon: lon)).responseObject {
            (response: DataResponse<OneCallObject, AFError>) in
            if response.error == nil {
                do {
                    let obj = try response.result.get()
                    completion(obj)
                }
                catch {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        }
    }
    
    private func googleBuildParameters(input: String) -> [String : String] {
        return [ "input": input,
                 "inputtype": "textquery",
                 "fields": "photos,formatted_address,name,rating,opening_hours,geometry",
                 "key": key]
    }
    
    func getCityCoordinates(name: String, completion: @escaping (Json4Swift_Base?) -> Void) {
        
        AF.request(googleApiUrl, method: .get, parameters: googleBuildParameters(input: name)).responseObject {
            (response: DataResponse<Json4Swift_Base, AFError>) in
            if response.error == nil {
                do {
                    print(response)
                    let obj = try response.result.get()
                    completion(obj)
                }
                catch {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        }
    }
    
}
