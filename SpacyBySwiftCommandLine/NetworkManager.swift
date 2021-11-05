//
//  NetworkManager.swift
//  SpacyBySwiftCommandLine
//
//  Created by 孙世伟 on 2021/11/5.
//

import Foundation


enum EncodeWay {
    case utf8, GB2312
}


class NetworkManager {
    static let shared = NetworkManager()
    
    var request: URLRequest
    var encodeWay: EncodeWay = .utf8
    
    private init() {
        request = URLRequest(url: URL(string: "https://www.baidu.com/")!)
    }
}
// - Part: foundationFunction
extension NetworkManager {
    /**
     Set request aim url
     */
    private func setRequestUrl(_ str: String) {
        request = URLRequest(url: URL(string: str)!)
    }
    
    private func setMethodGet() {
        request.httpMethod = "GET"
    }
    
    private func startResume() -> String {
        var commandLineSP = false
        var result: String = ""
        let tast = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                switch self.encodeWay {
                case .utf8:
                    result = self.encodingByUtf8(data)
                case .GB2312:
                    result = self.encodingByGB2312(data)
                }
            } else {
                print(error!)
            }
            commandLineSP = true
        }
        tast.resume()
        while !commandLineSP {
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
        }
        return result
    }
}

// - Part: normalGetRequest
extension NetworkManager {
    func normalSpacy(_ str: String) -> String{
        setRequestUrl(str)
        setMethodGet()
        return startResume()
    }
}


// - Part: EncodingFunction
extension NetworkManager {
    private func encodingByUtf8(_ data: Data) -> String {
        if let res = String(data: data, encoding: .utf8) {
            return res
        }
        return "---- utf-8 Return Error ----"
    }
    
    private func encodingByGB2312(_ data: Data) -> String {
        let GB2312Encoding =  CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        if let res = String(data: data, encoding: String.Encoding(rawValue: GB2312Encoding)) {
            return res
        }
        return "---- GB2312 Return Error ----"
    }
}
