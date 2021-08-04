//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Anastasiia on 20.07.2021.
//

import UIKit

class SettingsView: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var pickerview_doneButton: UIBarButtonItem!
    @IBOutlet weak var pickerview_skipButton: UIBarButtonItem!
    
    var unitsPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 245))
    @IBOutlet weak var unitsField: UITextField!
    let units = ["Standart", "Metric", "Imperial"]
    
    var languagesPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 245))
    @IBOutlet weak var languagesField: UITextField!
    let languages = ["en", "ru", "ua"]
    
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        pickerView.isHidden = true
        pickerview_doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
        
        //MARK: - units
        unitsField.attributedPlaceholder = NSAttributedString(string: SettingsManager.shared.requestUnit.rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 67.0 / 255.0, green: 44.0 / 255.0, blue: 129.0 / 255.0, alpha: 1)])
        unitsField.inputView = unitsPicker
        
        unitsPicker.delegate = self
        unitsPicker.dataSource = self
        unitsPicker.isHidden = true
        unitsPicker.tag = 1
        
        
        //MARK: - languages
        languagesField.attributedPlaceholder = NSAttributedString(string:  SettingsManager.shared.requestLanguage.rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 67.0 / 255.0, green: 44.0 / 255.0, blue: 129.0 / 255.0, alpha: 1)])
        languagesField.inputView = languagesPicker
        
        languagesPicker.delegate = self
        languagesPicker.dataSource = self
        languagesPicker.isHidden = true
        languagesPicker.tag = 2
    }
    
    @IBAction func cancel_Clicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func done_Clicked(_ sender: UIButton) {
        // TODO: Save Settings
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pickerview_skipButton_Clicked(_ sender: UIBarButtonItem) {
        self.pickerView.isHidden = true
        if unitsPicker.isHidden == false {
            unitsField.resignFirstResponder()
            unitsPicker.isHidden = true
        }
        else if languagesPicker.isHidden == false {
            languagesField.resignFirstResponder()
            languagesPicker.isHidden = true
        }
        else { return }
    }
    
    @IBAction func pickerView_doneButton_Clicked(_ sender: UIBarButtonItem) {
        self.pickerView.isHidden = true
        if unitsPicker.isHidden == false {
            unitsField.placeholder = SettingsManager.shared.requestUnit.rawValue
            unitsField.resignFirstResponder()
            unitsPicker.isHidden = true
        }
        else if languagesPicker.isHidden == false {
            languagesField.placeholder = SettingsManager.shared.requestLanguage.rawValue
            languagesField.resignFirstResponder()
            languagesPicker.isHidden = true
        }
        else { return }
    }
    
    
    
    //MARK: -
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
}


// MARK: - extension for PickerView
extension SettingsView : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return RequestUnitType.allCases.count
        case 2:
            return RequestLangType.allCases.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView.backgroundColor = .systemGray6
        self.pickerView.isHidden = false
        switch pickerView.tag {
        case 1:
            unitsPicker.isHidden = false
            return units[row]
        case 2:
            languagesPicker.isHidden = false
            return languages[row]
        default:
            return "error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            if row == 0 {
                SettingsManager.shared.requestUnit = .unitStandart
            }
            else if row == 1 {
                SettingsManager.shared.requestUnit = .unitMetric
            }
            else if row == 2 {
                SettingsManager.shared.requestUnit = .unitImperial
            }
            
        case 2:
            if row == 0 {
                SettingsManager.shared.requestLanguage = .langEn
            }
            else if row == 1 {
                SettingsManager.shared.requestLanguage = .langRu
            }
            else if row == 2 {
                SettingsManager.shared.requestLanguage = .langUa
            }
            
        default:
            return
        }
    }
    
}

