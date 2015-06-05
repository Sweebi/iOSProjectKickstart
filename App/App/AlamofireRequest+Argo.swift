//
//  AlamofireRequest+Argo.swift
//  App
//
//  Created by Cédric Eugeni on 05/06/2015.
//  Copyright (c) 2015 Cédric Eugeni. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import Runes

extension Alamofire.Request {
    public func responseArgoObject<T: Decodable where T == T.DecodedType>(completionHandler: (success: Bool, successObject: T?, errorObject: NSError?) -> Void) -> Self {
        return response(serializer: Request.JSONResponseSerializer(), completionHandler: { (request, response, responseJSON, alamofireError) in
            println(request)
            println(response)
            println(alamofireError)
            
            if let object: AnyObject = responseJSON {
                if let error = alamofireError {
                    if let decodedError: NSError? = decode(object) {
                        completionHandler(success: false, successObject: nil, errorObject: decodedError)
                    } else {
                        completionHandler(success: false, successObject: nil, errorObject: NSError(domain: "", code: -100, userInfo: ["app": "parsing error in error server"]))
                    }
                } else {
                    let decodedObject: Decoded<T> = decode(object)
                    
                    switch decodedObject {
                    case .MissingKey(let message):
                        completionHandler(success: false, successObject: nil, errorObject: NSError(domain: "", code: -100, userInfo: ["app Missing Key": message]))
                    case .TypeMismatch(let message):
                        completionHandler(success: false, successObject: nil, errorObject: NSError(domain: "", code: -100, userInfo: ["app Type Mismatch": message]))
                    case .Success(let value):
                        completionHandler(success: true, successObject: decodedObject.value, errorObject: nil)
                    }
                }
            }
        })
    }
    
    public func responseArgoArray<T: Decodable where T == T.DecodedType>(completionHandler: (success: Bool, successObject: [T]?, errorObject: NSError?) -> Void) -> Self {
        return response(serializer: Request.JSONResponseSerializer(), completionHandler: { (request, response, responseJSON, alamofireError) in
            println(request)
            println(response)
            println(alamofireError)
            
            if let object: AnyObject = responseJSON {
                if let error = alamofireError {
                    if let decodedError: NSError? = decode(object) {
                        completionHandler(success: false, successObject: nil, errorObject: decodedError)
                    } else {
                        completionHandler(success: false, successObject: nil, errorObject: NSError(domain: "", code: -100, userInfo: ["app": "parsing error in error server"]))
                    }
                } else {
                    let decodedObject: Decoded<[T]> = decode(object)
                    
                    switch decodedObject {
                    case .MissingKey(let message):
                        completionHandler(success: false, successObject: nil, errorObject: NSError(domain: "", code: -100, userInfo: ["app Missing Key": message]))
                    case .TypeMismatch(let message):
                        completionHandler(success: false, successObject: nil, errorObject: NSError(domain: "", code: -100, userInfo: ["app Type Mismatch": message]))
                    case .Success(let value):
                        completionHandler(success: true, successObject: decodedObject.value, errorObject: nil)
                    }
                }
            }
        })
    }
}