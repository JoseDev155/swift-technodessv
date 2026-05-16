import Foundation

enum NetworkError: Error {
    case invalidURL
    case httpError(statusCode: Int)
    case decodingError
    case transportError(Error)
}

protocol NetworkServiceProtocol {
    func fetchNodes() async throws -> [TechNode]
}

class NetworkService: NetworkServiceProtocol {
    func fetchNodes() async throws -> [TechNode] {
        guard let url = URL(string: Environment.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw NetworkError.transportError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpError(statusCode: 0)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            // URLSession skill: Handle HTTP errors because URLSession does not throw on 404/500
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode([TechNode].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
