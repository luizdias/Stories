import Foundation

struct Story: Decodable {
    let id: String
    let title: String
    let cover: String
    let user: User
}
