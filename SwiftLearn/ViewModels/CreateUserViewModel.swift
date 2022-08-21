//
// Created by Admin on 2022-08-17.
//

import Foundation
import UIKit

class CreateUserViewModel {

    func createUser(image: UIImage, name: String, email: String, viewController: AddUserViewController) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        ApiManager.shared.createUser(imageData: imageData, imageDataFieldName: ["avatar"], formFields: ["name": name, "email": email]) { result in
            switch result {
                case .success(let data):
                    showAlert(title: "Success", message: "Successfully created", actions: [UIAlertAction(title: "Okay", style: .default) { action in
                        viewController.navigationController?.popViewController(animated: false)
                    }], preferredStyle: .alert, viewController: viewController)
                case .failure(let error):
                    showAlert(title: "Error", message: error.message ?? "Error while create user", actions: [UIAlertAction(title: "Okay", style: .default)], preferredStyle: .alert, viewController: viewController)

            }
        }
    }
}