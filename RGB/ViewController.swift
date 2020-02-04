//
//  ViewController.swift
//  RGB
//
//  Created by Andry Pro on 03.02.2020.
//  Copyright © 2020 Andry Pro. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var rgbView: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    var keyboardDissmisTapGesture: UITapGestureRecognizer?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRgb()
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        addDoneButtonTo(redTextField)
        addDoneButtonTo(greenTextField)
        addDoneButtonTo(blueTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func slidersChanged() {
        setupRgb()
    }
    
    // MARK: - Private Methods
    
    private func setupRgb() {
        rgbView.backgroundColor = UIColor.init(red: CGFloat(redSlider!.value), green: CGFloat(greenSlider!.value), blue: CGFloat(blueSlider!.value), alpha: 1)
        
        redLabel.text = String(format: "%.2f", redSlider.value)
        redTextField.text = String(format: "%.2f", redSlider.value)
        
        greenLabel.text = String(format: "%.2f", greenSlider.value)
        greenTextField.text = String(format: "%.2f", greenSlider.value)
        
        blueLabel.text = String(format: "%.2f", blueSlider.value)
        blueTextField.text = String(format: "%.2f", blueSlider.value)
    }
}

// MARK: - UITextFieldDelegate methods

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.first == "." {
            textField.text = "0."
        }
        if text == "0" {
            textField.text = "0."
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case redTextField:
            dataTranmision(from: redTextField, to: redSlider)
        case greenTextField:
            dataTranmision(from: greenTextField, to: greenSlider)
        case blueTextField:
            dataTranmision(from: blueTextField, to: blueSlider)
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dataTranmision(from textField: UITextField, to slider: UISlider) {
        guard let textInput = textField.text else { return }
        guard let value = Float(textInput) else {
            allertController()
            return
        }
        if value >= 0 && value <= 1 {
            slider.value = value
            setupRgb()
        } else {
            allertController()
        }
    }
}

// Work with keyboard

extension ViewController {
    private func addDoneButtonTo(_ textField: UITextField) {
        
        let keyboardToolbar = UIToolbar()
        textField.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title:"Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
    
    @objc private func didTapDone() {
        self.view.endEditing(true)
    }
    
    func allertController() {
        let alert = UIAlertController(title: "Wrong format!",
                                      message: "Please enter a number in the range from 0 to 1",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    func dissmisKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


