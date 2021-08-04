//
//  CityCell.swift
//  WeatherApp
//
//  Created by Anastasiia on 01.08.2021.
//

import UIKit

class CityCell: UICollectionViewCell {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
