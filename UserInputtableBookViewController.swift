//
//  InputtableBookViewController.swift
//  ProlificLibrary
//
//  Created by Daniel Nomura on 10/27/16.
//  Copyright © 2016 Daniel Nomura. All rights reserved.
//

import Foundation
import UIKit

protocol UserInputtableBookViewController: class, UITextFieldDelegate {
    var textFields: [UITextField] { get }
    var textlessTextFields: [UITextField] { get }
    var textlessPlaceholders: [String] { get }
    var textfulTextFields: [UITextField] { get }
    var textfulPlaceholders: [String] { get }
    func showAlertForTextfulTextFields()
    func showAlertForTextlessTextFields()
    func dismissSelfOrShowAlert()
    func submitBook()
    func submitBookOrShowAlert()
}

extension UserInputtableBookViewController where Self: UIViewController {
    var textlessTextFields: [UITextField] {
        return textFields.flatMap{ return !$0.hasText ? $0 : nil }
    }
    var textlessPlaceholders: [String] {
        return textlessTextFields.map{ return $0.placeholder! }
    }
    var textfulTextFields: [UITextField] {
        return textFields.flatMap{ return $0.hasText ? $0 : nil }
    }
    var textfulPlaceholders: [String] {
        return textfulTextFields.map{ return $0.placeholder! }
    }
    
    func showAlertForTextfulTextFields() {
        let alertController = UIAlertController.init(title: "Book information will not be saved to the library", message: "Woud you like to leave?", preferredStyle: .alert)
        let leaveAction = UIAlertAction.init(title: "Leave", style: .default, handler: { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        })
        let stayAction = UIAlertAction.init(title: "Stay", style: .default, handler: nil)
        alertController.addAction(leaveAction)
        alertController.addAction(stayAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertForTextlessTextFields() {
        let textlessPlaceholders = textlessTextFields.map{ return $0.placeholder! }
        let emptyFields = textlessPlaceholders.joined(separator: ", ")
        let alertController = UIAlertController.init(title: "Need to add \(emptyFields)", message: "Please fill out all text fields", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Okay", style: .default, handler: { [unowned self] _ in
            self.textlessTextFields[0].becomeFirstResponder()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func submitBookOrShowAlert() {
        if textlessTextFields.count > 0 {
            showAlertForTextlessTextFields()
        } else {
            submitBook()
        }
    }
    
    func dismissSelfOrShowAlert() {
        if textfulTextFields.count > 0 {
            showAlertForTextfulTextFields()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func handleTextFieldShouldReturn(_ textField: UITextField) {
        if let textFieldIndex = textFields.index(of: textField) {
            if textFieldIndex == textFields.count - 1 {
                submitBookOrShowAlert()	
            } else {
                textFields[textFieldIndex.advanced(by: 1)].becomeFirstResponder()
            }
        }
    }
}

