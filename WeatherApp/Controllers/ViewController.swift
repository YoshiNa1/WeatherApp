//
//  ViewController.swift
//  WeatherApp
//
//  Created by Anastasiia on 15.07.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var currTempLabel: UILabel!
    @IBOutlet weak var currDescriptionLabel: UILabel!
    @IBOutlet weak var currDateLabel: UILabel!
    @IBOutlet weak var nowWeatherImage: UIImageView!
    @IBOutlet weak var currHumidityLabel: UILabel!
    @IBOutlet weak var currUvLabel: UILabel!
    @IBOutlet weak var currWindLabel: UILabel!
    
    @IBOutlet weak var weatherFor7DaysCollectionView: UICollectionView!
    
    @IBOutlet weak var citiesCollectionView: UICollectionView!
    
    
    private var locationManager : CLLocationManager?
   
    public var model : OneCallObject?
    var dailyWeather: [Daily]?
    var currentWeather: Current?
    
    
    public var cities : [OneCallObject]? = Array<OneCallObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        nowWeatherImage.image = UIImage(named: "cloudy")
        
        self.weatherFor7DaysCollectionView.register(UINib(nibName: "DayCell", bundle: nil), forCellWithReuseIdentifier: "DayCell")
        
        weatherFor7DaysCollectionView.delegate = self
        weatherFor7DaysCollectionView.dataSource = self
        weatherFor7DaysCollectionView.tag = 1
        
        self.citiesCollectionView.register(UINib(nibName: "CityCell", bundle: nil), forCellWithReuseIdentifier: "CityCell")
        
        citiesCollectionView.delegate = self
        citiesCollectionView.dataSource = self
        citiesCollectionView.tag = 2
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    @IBAction func settings_Clicked(_ sender: UIButton) {
        showMiracle()
    }
   
    func showMiracle() {
       let slideVC = SettingsView()
       slideVC.modalPresentationStyle = .custom
       slideVC.transitioningDelegate = self
       self.present(slideVC, animated: true, completion: nil)
    }

    func updateUI() {
        if let timeResult = (self.currentWeather?.dt) {
            let date = Date(timeIntervalSince1970: TimeInterval(timeResult))
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
            formatter.timeZone = .current
            let localDate = formatter.string(from: date)
            self.currDateLabel.text = localDate
        }
        self.navigationItem.title = self.model?.timezone
        let image = self.currentWeather?.weather?[0].icon
        let url = URL(string: "https://openweathermap.org/img/wn/\(image ?? "")@2x.png")!
        self.nowWeatherImage.load(url: url)
        
        self.currDescriptionLabel.text = "| \(self.currentWeather?.weather?[0].description?.capitalized ?? "Partly Cloudy")"
        self.currTempLabel.text = String(format: "%.0f°", self.currentWeather?.temp ?? 0.0)
        self.currHumidityLabel.text = "\(self.currentWeather?.humidity ?? 0)%"
        self.currUvLabel.text = "\(self.currentWeather?.uvi ?? 0)"
        self.currWindLabel.text = "E \(self.currentWeather?.wind_speed ?? 0) kmh"
        
    }
    
    func getCities() {
        DispatchQueue.main.async {
            self.cities?.removeAll()
            self.addCity(lat: "46.4775", lon: "30.7326")
            self.addCity(lat: "50.4500", lon: "30.5233")
            self.addCity(lat: "52.5200", lon: "13.4049")
            self.addCity(lat: "40.7306", lon: "-73.9352")
        }
    }
    
    func addCity(lat: String, lon: String) {
        let lat = lat
        let lon = lon
        NetworkManager.shared.getOneCallObjectCall(lat: lat, lon: lon) { [weak self] object in
            self?.cities?.append(object!)
        }
    }
    
    
    @IBAction func edit_Clicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCities", sender: self.cities)
    }
    
}
//MARK: - extension for CollectionView
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
//            return dailyWeather?.count ?? 0
            return 7
        case 2:
//            print(self.cities?.count ?? 0)
//            return self.cities!.count
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = weatherFor7DaysCollectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
            
            let image = self.dailyWeather?[indexPath.item].weather?[0].icon
            let url = URL(string: "https://openweathermap.org/img/wn/\(image ?? "")@2x.png")!
            cell.nowWeatherImage.load(url: url)
            
            cell.temperatureLabel.text = String(format: "%.0f°", dailyWeather?[indexPath.item].temp?.day ?? 0.0)
            
            if let timeResult = (self.dailyWeather?[indexPath.item].dt) {
                let date = Date(timeIntervalSince1970: TimeInterval(timeResult))
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateStyle = .medium
                formatter.timeZone = .current
                let localDate = formatter.string(from: date)
                cell.dateLabel.text = localDate
            }
            return cell
        
        case 2:
            let cell = citiesCollectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CityCell
            
            if self.cities!.count > 0 && indexPath.row < self.cities!.count {
                let currCity = self.cities?[indexPath.item].current
            
                let image = currCity?.weather?[0].icon
                let url = URL(string: "https://openweathermap.org/img/wn/\(image ?? "")@2x.png")!
                cell.weatherImage.load(url: url)
            
                cell.tempLabel.text = String(format: "%.0f°", self.cities?[indexPath.item].current?.temp ?? 0.0)
                cell.cityName.text = self.cities?[indexPath.item].timezone
            }
            return cell
            
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "UICell", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            print("cell tapped")
            self.performSegue(withIdentifier: "toDailyVC", sender: indexPath.item)
        case 2:
            print("cell tapped")
        default:
            print("error")
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? DailyWeatherViewController{
            let selectedRow = sender as? Int
            if let name = dailyWeather?[selectedRow!]{
                if let timeResult = name.dt {
                    let date = Date(timeIntervalSince1970: TimeInterval(timeResult))
                    let formatter = DateFormatter()
                    formatter.timeStyle = .none
                    formatter.dateStyle = .medium
                    formatter.timeZone = .current
                    let localDate = formatter.string(from: date)
                    destination.navigationItem.title = localDate
                }
                
                let image = name.weather?[0].icon
                let url = URL(string: "https://openweathermap.org/img/wn/\(image ?? "")@2x.png")!
                let session = URLSession.shared
                let task = session.dataTask(with: url) { (data, _, error) in
                    if error == nil, let data = data {
                        destination.w_img = UIImage(data: data)
                    }
                }
                task.resume()
                
                destination.descriptionL = "| \(name.weather?[0].description?.capitalized ?? "Partly Cloudy")"
                destination.dayTemp = String(format: "%.0f°", name.temp?.day ?? 0.0)
                destination.minL = String(format: "%.0f°", name.temp?.min ?? 0.0)
                destination.maxL = "\(name.temp?.max ?? 0)°"
                destination.wind = "E \(name.wind_speed ?? 0) kmh"
                destination.humidity = "\(name.humidity ?? 0)%"
                destination.pressure = "\(name.wind_speed ?? 0) hPa"
                destination.uv = "\(name.uvi ?? 0)"
                
                destination.morningTemp = String(format: "%.0f°", name.temp?.morn ?? 0.0)
                destination.afternoonTemp = String(format: "%.0f°", name.temp?.day ?? 0.0)
                destination.eveningTemp = String(format: "%.0f°", name.temp?.eve ?? 0.0)
                destination.nightTemp = String(format: "%.0f°", name.temp?.night ?? 0.0)
                
                destination.morningFeel = String(format: "%.0f°", name.feels_like?.morn ?? 0.0)
                destination.afternoonFeel = String(format: "%.0f°", name.feels_like?.day ?? 0.0)
                destination.eveningFeel = String(format: "%.0f°", name.feels_like?.eve ?? 0.0)
                destination.nightFeel = String(format: "%.0f°", name.feels_like?.night ?? 0.0)
                
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
                
            }
        }
        if let citiesVC = segue.destination as? CitiesViewController{
            citiesVC.addedCities = self.cities
        }
    }
    
    
}

//MARK: - extension for SettingsView
extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK: - Location Manager extension
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            let lat = String(format: "%.4f", loc.coordinate.latitude)
            let lon = String(format: "%.4f", loc.coordinate.longitude)
            
            NetworkManager.shared.getOneCallObjectCall(lat: lat, lon: lon) { [weak self] object in
                self?.model = object
                self?.currentWeather = object?.current
                self?.dailyWeather = object?.daily
               
                DispatchQueue.main.async {
                    self?.getCities()
                    self?.updateUI()
                    self?.citiesCollectionView.reloadData()
                    self?.weatherFor7DaysCollectionView.reloadData()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

//MARK: - ImageView extension
extension UIImageView {
    func load(url: URL) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            if error == nil, let data = data {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
}


