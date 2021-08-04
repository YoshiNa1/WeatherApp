//
//  DailyWeatherViewController.swift
//  WeatherApp
//
//  Created by Anastasiia on 15.07.2021.
//

import UIKit

class DailyWeatherViewController: UIViewController {

    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    
    var dayTemp : String!
    var descriptionL : String!
    var minL : String!
    var maxL : String!
    var wind : String!
    var humidity : String!
    var pressure : String!
    var uv : String!
    
    @IBOutlet weak var weatherImage: UIImageView!
    var w_img: UIImage!
    
    @IBOutlet weak var morningView: DailyWeatherView!
    @IBOutlet weak var afternoonView: DailyWeatherView!
    @IBOutlet weak var eveningView: DailyWeatherView!
    @IBOutlet weak var nightView: DailyWeatherView!
    
    var morningTemp : String!
    var morningFeel : String!
    var afternoonTemp : String!
    var afternoonFeel : String!
    var eveningTemp : String!
    var eveningFeel : String!
    var nightTemp : String!
    var nightFeel : String!
    
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var humidityImage: UIImageView!
    @IBOutlet weak var uvImage: UIImageView!
    @IBOutlet weak var pressureImage: UIImageView!
    
    var gl:CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        morningView.dayTimeLabel.text = "Morning"
        afternoonView.dayTimeLabel.text = "Afternoon"
        eveningView.dayTimeLabel.text = "Evening"
        nightView.dayTimeLabel.text = "Night"
        
        self.windImage.image = UIImage(named: "wind")
        self.humidityImage.image = UIImage(named: "humidity")
        self.uvImage.image = UIImage(named: "uv")
        self.pressureImage.image = UIImage(named: "pressure")
        
        weatherImage.image = w_img
        descriptionLabel.text = descriptionL
        dayTempLabel.text = dayTemp
        minLabel.text = minL
        maxLabel.text = maxL
        windLabel.text = wind
        humidityLabel.text = humidity
        pressureLabel.text = pressure
        uvLabel.text = uv
        
        morningView.tempValueLabel.text = morningTemp
        morningView.feelsValueLabel.text = morningFeel
        afternoonView.tempValueLabel.text = afternoonTemp
        afternoonView.feelsValueLabel.text = afternoonFeel
        eveningView.tempValueLabel.text = eveningTemp
        eveningView.feelsValueLabel.text = eveningFeel
        nightView.tempValueLabel.text = nightTemp
        nightView.feelsValueLabel.text = nightFeel
        
        
        setGradientBackground(view: morningView, colorLeft: UIColor(red: 147.0 / 255.0, green: 209.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor, colorRight: UIColor.white.cgColor)
        setGradientBackground(view: afternoonView, colorLeft: UIColor(red: 250.0 / 255.0, green: 205.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0).cgColor, colorRight: UIColor.white.cgColor)
        setGradientBackground(view: eveningView, colorLeft: UIColor(red: 255.0 / 255.0, green: 166.0 / 255.0, blue: 175.0 / 255.0, alpha: 1.0).cgColor, colorRight: UIColor.white.cgColor)
        setGradientBackground(view: nightView, colorLeft: UIColor(red: 0.0 / 255.0, green: 179.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0).cgColor, colorRight: UIColor.white.cgColor)
    }
    
    
    func setGradientBackground(view: UIView, colorLeft : CGColor, colorRight: CGColor) {
        self.gl = CAGradientLayer()
        gl.colors = [colorLeft, colorRight]
        gl.startPoint = CGPoint(x: 0.0, y: 0.5)
        gl.endPoint = CGPoint(x: 1.0, y: 0.5)
        gl.frame = view.bounds
        
        view.layer.insertSublayer(gl, at: 0)
    }
}
