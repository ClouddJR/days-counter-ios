import Foundation

struct ImagesResponse: Decodable {
    var total: Int
    var results: [InternetImage]
}

struct InternetImage: Decodable {
    var id: String
    var user: ImageAuthor
    var urls: ImageUrls
}

struct ImageAuthor: Decodable {
    var username: String
    var name: String
}

struct ImageUrls: Decodable {
    var raw: String
    var full: String
    var regular: String
    var small: String
}
