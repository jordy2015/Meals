//
//  ApiClient.swift
//  soyfri
//
//  Created by Jordy Gonzalez on 3/6/23.
//

import Foundation
import Alamofire
import CodableAlamofire

protocol NetworkProtocol {
    func performRequest<T: Decodable>(to url: String,
                                      httpMethod: HttpMethod,
                                      keyPath: String?,
                                      body: [String: AnyObject]?,
                                      completitionHandler: @escaping(_ response: T?, _ error: Error?) -> Void)
}

class ApiClient: NetworkProtocol {
    
    static let `default` = ApiClient()
    
    func performRequest<T: Decodable>(to url: String,
                                      httpMethod: HttpMethod,
                                      keyPath: String?,
                                      body: [String: AnyObject]?,
                                      completitionHandler: @escaping(_ response: T?, _ error: Error?) -> Void
    ) {
        AF.request(url, method: HTTPMethod(rawValue: httpMethod.rawValue), parameters: body)
            .validate()
            .responseDecodableObject(keyPath: keyPath) { (response: AFDataResponse<T>) in
                if let result = response.value {
                    completitionHandler(result, nil)
                }
                
                if let error = response.error {
                    completitionHandler(nil, error)
                }
            }
    }
}

enum HttpMethod: String {
    case Get
    case Post
    case Delete
}
