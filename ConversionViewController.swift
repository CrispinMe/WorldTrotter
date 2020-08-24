//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Crispin Lloyd on 06/10/2017.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view")
        
        updateCelciusLabel()
    }
    
    @IBOutlet var celciusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()

    
    var fahrenheitValue: Measurement<UnitTemperature>?{
        didSet {
            updateCelciusLabel()
        }
    }
    
    var celciusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
            
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dimissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelciusLabel () {
        if let celciusValue = celciusValue {
            celciusLabel.text = numberFormatter.string(from: NSNumber(value: celciusValue.value))
        } else {
            celciusLabel.text = "???"
        }
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // print("Current text: \(String(describing: textField.text)) ")
        // print("Replacement text: \(string)")
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        
            let alphanumericsCharacterSet = CharacterSet.letters
            let alphanumericsCharacterSetNS = alphanumericsCharacterSet as NSCharacterSet
           
            
            for c in string.utf16 {
                if alphanumericsCharacterSetNS.characterIsMember(c) == true {
                    
                    return false

                }
                
                break
        }
        
                if  existingTextHasDecimalSeparator != nil,
                replacementTextHasDecimalSeparator != nil {
                    
                    return false
                    
                } else {
                    
                    return true
                }
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        let userCalendar = Calendar.current
        let today = Date()
        let hourTime = userCalendar.component(.hour, from: today)
        let currentMonth = userCalendar.component(.month, from: today)
        
 

            if (currentMonth < 3 || currentMonth > 10) && hourTime >= 18 {
                
                self.view.backgroundColor = UIColor.darkGray
                
            } else if  hourTime > 19 {
                
                self.view.backgroundColor = UIColor.lightGray

                
                } else {
                    
                    self.view.backgroundColor = UIColor.white
            }
       
    }
    
        }


