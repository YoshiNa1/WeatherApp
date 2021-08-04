//
//  DailyWeatherView.swift
//  WeatherApp
//
//  Created by Anastasiia on 25.07.2021.
//

import UIKit

class DailyWeatherView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLabel: UILabel!
    
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var feelsValueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DailyWeatherView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
