//
//  UserTableViewCell.swift
//  SwiftLearn
//
//  Created by Admin on 2022-07-28.
//

import Foundation
import UIKit


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil,
                            let image = UIImage(data: data)
                    else {
                        return
                    }
                    DispatchQueue.main.async() { [weak self] in
                        self?.image = image
                    }
                }
                .resume()
    }

    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            return
        }
        downloaded(from: url, contentMode: mode)
    }
}

class UserTableViewCell: UITableViewCell {

    lazy var name: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    lazy var avatar: UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame = frame
        iv.layer.cornerRadius = iv.frame.height * 0.5
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setUpLayout()
    }

    func addViews() {
        contentView.addSubview(name)
        contentView.addSubview(avatar)
    }

    func setUpLayout() {
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
