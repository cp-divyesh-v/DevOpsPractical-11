//
//  WebService.swift
//  DevOpsPractical8
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import Foundation
import Alamofire

protocol WebServiceProtocol {
    func request<T: Decodable>(url: String, method: HTTPMethod, parameter: Parameters, headers: HTTPHeaders?, success: @escaping (Data, Int, T) -> Void, failure: @escaping (Error) -> Void)
}

class WebService: WebServiceProtocol {
    func request<T: Decodable>(url: String, method: HTTPMethod, parameter: Parameters, headers: HTTPHeaders?, success: @escaping (Data, Int, T) -> Void, failure: @escaping (Error) -> Void) {
            AF.request(url, method: method, parameters: parameter, encoding: URLEncoding.queryString, headers: headers).responseDecodable(of: T.self) { responseObject -> Void in
                switch responseObject.result {
                case .success(let value):
                    if let data = responseObject.data {
                        let statusCode = responseObject.response?.statusCode ?? 0
                        success(data, statusCode, value)
                    }
                case .failure(let error):
                    failure(error)
                }
            }
        }
}
