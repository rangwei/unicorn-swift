//
//  AlertHelper.swift
//  hubspot2
//
//  Created by Rang, Winters on 2019/2/16.
//  Copyright © 2019 Rang, Winters. All rights reserved.
//
import Foundation
import UIKit

class AlertHelper {
    static let okTitle = "OK"
    
    static func displayAlert(with title: String, error: Error?, buttonTitle: String = AlertHelper.okTitle, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: error?.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default))
        DispatchQueue.main.async {
            // Present the alertController
            viewController.present(alertController, animated: true)
        }
    }
}

