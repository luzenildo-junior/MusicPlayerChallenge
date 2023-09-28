//
//  APIConfiguration.swift
//  MusicPlayerChallenge
//
//  Created by Luzenildo Junior on 21/09/23.
//

import Foundation

struct APIConstants {
    static let baseURL = "https://itunes.apple.com/"
}

/// Protocol to setup requests
protocol APIRequest: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParameters { get }
}

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension APIRequest {
    // MARK: - asURLRequested method
    func asURLRequest() throws -> URLRequest {
        // URL
        let url = URL(string: APIConstants.baseURL)
        var urlRequest = URLRequest(url: (url?.appendingPathComponent(path))!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Parameters
        switch parameters {
        case .body(let params):
            if params.count > 0 {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params,
                                                                 options: [])
            }
        case .queryItems(let params):
            let queryParams = params.map { pair in
                return URLQueryItem(name: pair.key,
                                    value: "\(pair.value)")
            }
            var components = URLComponents(string: (url?.appendingPathComponent(path).absoluteString)!)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
        return urlRequest
    }
}
