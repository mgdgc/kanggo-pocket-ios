//
//  NewMealParser.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 5. 1..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

protocol NewMealParserDelegate {
    func onParseFinished(result: String)
    func onConvertFinished(meal: String)
}

class NewMealParser {
    
    var url = "http://kanggo.net/sFoodList/popup/view.do"
    
    public let breakfast = "B"
    public let lunch = "M"
    public let dinner = "D"
    
    public var delegate: NewMealParserDelegate? = nil
    
    func setCustomUrl(customUrl: String) {
        self.url = customUrl
    }
    
    func getCookie() {
        let host = "http://kanggo.net"
        
        let session = Alamofire.SessionManager.default
        session.request(host)
            .responseJSON(completionHandler: { res in
                guard let headers = res.response?.allHeaderFields as? [String : String] else {
                    return
                }
                if headers["Set-Cookie"] != nil {
                    headers["Set-Cookie"]!
                } else {
                    return
                }
            })
    }
    
    func parseData(year: String, month: String, day: String, mealCode: String) {
        let host = "http://kanggo.net"
        let session = Alamofire.SessionManager.default
        session.request(host)
            .responseData { (responseObject) in
                if let responseStatus = responseObject.response?.statusCode {
                    if responseStatus != 200 {
                        return
                    } else {
                        print(HTTPCookieStorage.shared.cookies!)
                    }
                }
        }
        
        let parameters: Parameters = [
            "year" : year,
            "month" : month,
            "day" : day,
            "foodType" : mealCode
        ]
        
        var cookie = ""
        
        let headers: HTTPHeaders = [
            "Cookie" : cookie
        ]
        
        var url = ""
        
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(completionHandler: { response in
                //            if let json = response.result.value {
                //                // TODO: handle json
                //            }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print(utf8Text)
                    //                if self.delegate != nil {
                    //                    self.delegate?.onParseFinished(result: utf8Text)
                    //                }
                    
                }
            })
    }
    
    func convertData(data: String) -> Bool {
        guard let document = try? Kanna.HTML(html: data, encoding: .utf8) else {
            return false
        }
        
        var tr = ""
        for t in document.xpath("//tr") {
            if let trString = t.toHTML {
                if trString.contains("메뉴") {
                    tr = trString
                }
            }
        }
        
        guard let document2 = try? Kanna.HTML(html: tr, encoding: .utf8) else {
            return false
        }
        
        let tds = document2.xpath("//td")
        let div = tds[0].xpath("//div")
        let meal = div[0].text
        
        if meal == nil {
            return false
        }
        
        //        if delegate != nil {
        //            delegate?.onConvertFinished(meal: meal!)
        //        }
        
        return true
    }
    
}

