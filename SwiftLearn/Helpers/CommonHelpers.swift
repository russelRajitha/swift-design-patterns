//
// Created by Admin on 2022-08-20.
//

import Foundation
import UIKit

func showAlert(title: String, message: String, actions: [UIAlertAction], preferredStyle: UIAlertController.Style, viewController: UIViewController) {
    DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for (item) in actions {
            alertController.addAction(item)
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
