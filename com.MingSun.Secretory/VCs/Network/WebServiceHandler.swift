//
//  WebServiceHandler.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 4/26/19.
//

import Foundation
import Alamofire

class WebServiceHandler {
	func requestJSON(url: URL, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil,
					 completion: @escaping (_ json: Any?, _ error: Error?) -> Void) {
		Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON {
			response in
			switch response.result {
			case .success(let data):
				completion(data, nil)
				break
			case .failure(let error):
				completion(nil, error)
			}
		}
	}
}
