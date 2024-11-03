import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case badHTTPResponse
    case authorizationError
    case noData
    case decodingError(Error)
    case unexpectedStatusCode(Int)
}
