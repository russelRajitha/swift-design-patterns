import Foundation

struct User: Codable {
    let id: Int
    let name, email: String
    let avatar: String
}