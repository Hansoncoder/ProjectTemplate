//
//  NetworkManager.swift
//  Hanson
//
//  Created by Hanson on 9/7/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {

    static let manager = NetworkManager()

    private override init() { }

    typealias NetworkCompletionHandler = (Alamofire.Result<Any>, _ msg: String? , _ code: Int?) -> Void
    typealias NetworkCompletionSimpleHandler = (Alamofire.Result<Any>) -> Void


    func upload(api: API, image: UIImage, to parameter: String, networkCompletionHandler: @escaping NetworkCompletionHandler) {
        guard let urlString = api.url,
            let url = URL(string: urlString),
            
            let data = image.jpegData(compressionQuality: 1)  else {
            printLog("URL Invalid: \(api)")
            return
        }
//        let token = User.loginUser()?.accessToken
//        let tokenData = token?.data(using: .utf8)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in

            let imageName = "headerIcon.png"
            multipartFormData.append(data, withName: parameter, fileName: imageName, mimeType: "image/png")
//            if let token = tokenData {
//                multipartFormData.append(token, withName: "access_token")
//            }
        },to: url, method: .post) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: {
                    let resultData = self.parseResult(result: $0.result, responseKey: "data")
                    networkCompletionHandler(resultData.result, resultData.msg, resultData.code)
                })
            case .failure(let error):
                let result = Result<Any>.failure(error)
                networkCompletionHandler(result,error.localizedDescription, 10000)
            }
        }
    }

    @discardableResult
    func fetchDataWithAPI(api: API,
                          method: HTTPMethod = .post,
                          responseKey: String = "data",
                          networkCompletionHandler: @escaping NetworkCompletionHandler) -> Cancellable? {
        guard let url = api.url else {
            printLog("URL Invalid: \(api)")
            return nil
        }

        return Alamofire.request(url, method: method, parameters: api.parameter).responseJSON {
            let resultData = self.parseResult(result: $0.result, responseKey: responseKey)
            networkCompletionHandler(resultData.result, resultData.msg, resultData.code)
        }
    }

    func parseResult(result: Alamofire.Result<Any>, responseKey: String)
        -> (result: Alamofire.Result<Any>, msg: String?, code: Int?) {

        // 网络错误，直接返回
        if result.isFailure {
            return (result,nil,nil)
        }

        // 处理数据，取出responseKey
        let data =  result
            .flatMap { $0 as? [String : Any] }
            .flatMap { $0?.valueFor(key: responseKey) }
            .mapError({ (error) -> Error in
                return error
            })

        // 数据取出失败，取出 state,返回错误信息
        let state = result
            .flatMap { $0 as? [String : Any] }
            .mapError({ (error) -> Error in
                return error
            })
        if let failure = state.value {
            return (data, failure["message"] as? String, failure["code"] as? Int)
        }
        return (data, nil, nil)
    }
}

// MARK: - 对字典扩展，实现ValueForKey方法，可以用.符号取值
extension Dictionary {
    var dictObject: Any? { return self}
    func valueFor(key: Key) -> Value? {
        guard let stringKey = (key as? String), stringKey.contains(".") else {
            return self[key]
        }
        let keys = stringKey.components(separatedBy: ".")

        guard !keys.isEmpty else {
            return nil
        }
        let results: Any? = keys.reduce(dictObject, fetchValueInObject)
        return results as? Value
    }
}

func fetchValueInObject(object: Any?, forKey key: String) -> Any? {
    return (object as? [String: Any])?[key]
}

// MARK: - 定义一个协议，让返回的request能取消请求
protocol Cancellable {
    func cancel()
}

extension Alamofire.Request: Cancellable {}

// MARK: - 错误类型
enum HTTPError: LocalizedError {
    case transformError
    case unknow

    var errorDescription: String? {
        switch self {
        case .transformError:
            return NSLocalizedString("transform json data error", comment: "transformError")
        case .unknow:
            return NSLocalizedString("unknow error", comment: "unknowError")
        }
    }

}

// MARK: - 扩展Alamofire 的 Result<Any>
extension Result {

    // Note: rethrows 用于参数是一个会抛出异常的闭包的情况，该闭包的异常不会被捕获，会被再次抛出，所以可以直接使用 try，而不用 do－try－catch

    // U 可能为 Optional
    func map<T>(_ transform: (Value) throws -> T) rethrows -> Result<T> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            return .success(try transform(value))
        }
    }

    // 若 transform 的返回值为 nil 则作为异常处理
    func flatMap<T>(_ transform: (Value) throws -> T?) rethrows -> Result<T> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            guard let transformedValue = try transform(value) else {
                return .failure(HTTPError.transformError)
            }
            return .success(transformedValue)
        }
    }

    // 适用于 transform(value) 之后可能产生 error 的情况
    func flatMap<T>(_ transform: (Value) throws -> Result<T>) rethrows -> Result<T> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            return try transform(value)
        }
    }

    // 处理错误，并向下传递
    func mapError(_ transform: (Error) throws -> Error) rethrows -> Result<Value> {
        switch self {
        case .failure(let error):
            return .failure(try transform(error))
        case .success(let value):
            return .success(value)
        }
    }

    // 处理数据（不再向下传递数据，作为数据流的终点）
    func handleValue(_ handler: (Value) -> Void) {
        switch self {
        case .failure(_):
            break
        case .success(let value):
            handler(value)
        }
    }

    // 处理错误（终点）
    func handleError(_ handler: (Error) -> Void) {
        switch self {
        case .failure(let error):
            handler(error)
        case .success(_):
            break
        }
    }
}
