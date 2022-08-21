//
//  UsersViewModel.swift
//  SwiftLearn
//
//  Created by Admin on 2022-07-27.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class UsersViewModel {
    var users = BehaviorSubject(value: [SectionModel(model: "", items: [User]())])

    func fetchUsers(refreshControl: UIRefreshControl?) {
        ApiManager.shared.getUsers() { result in
            switch result {
                case .success(let users):
                    let usersSection = SectionModel(model: "", items: users)
                    self.users.on(.next([usersSection]))
                    DispatchQueue.main.async {
                        refreshControl?.endRefreshing()
                    }
                case .failure(let error):
                    print(error.localizedDescription)

            }
        }
    }
}
