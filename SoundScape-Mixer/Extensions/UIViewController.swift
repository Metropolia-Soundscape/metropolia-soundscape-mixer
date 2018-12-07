//
//  UIViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/30/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var appController: AppController {
        return AppDelegate.appController
    }
    
    func displayWarningAlert(withTitle title: String?, errorMessage message: String?, cancelHandler handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            handler?()
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
