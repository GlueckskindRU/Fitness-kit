//
//  UIViewController.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

extension UIViewController {
    func showDialog(title: String?, message: String?, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок",
                                     style: .default,
                                     handler: completion
                                    )
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
