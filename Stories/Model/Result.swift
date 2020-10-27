import Foundation

struct Result: Decodable {
    let stories: [Story]
    let nextUrl: String
}
