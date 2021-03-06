//
//  ConnectionManager.swift
//  PruebaConceptoElTiempo
//
//  Created by mespinal on 5/03/21.
//

import Foundation
import Alamofire

protocol ConnectionManagerProtocol
{
    func getApoloList(handler: @escaping (BaseConnectionModel?, NSError?) -> Void)
}

public class ConnectionManager: ConnectionManagerProtocol
{
    static let shareInstance = ConnectionManager()
    
    let serverUrl = "https://images-api.nasa.gov/search?q=apollo%2011"
    
    func getApoloList(handler: @escaping (BaseConnectionModel?, NSError?) -> Void)
    {
        let url = serverUrl
        
        AF.session.configuration.timeoutIntervalForRequest = 10
                
        AF.request(url).validate().responseDecodable(of: BaseConnectionModel.self) { (response) in
                    
                    switch response.result
                    {
                    case .success(let value):
                        handler(value, nil)
                    case .failure(let error):
                        let newError = NSError(domain: url, code: (response.response?.statusCode ?? 0)!, userInfo:[NSLocalizedDescriptionKey:error.localizedDescription])
                            
                        handler(nil, newError)
                    }
                }
    }
}
