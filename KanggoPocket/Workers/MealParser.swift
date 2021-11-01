//
//  MealParser.swift
//  MealParser
//
//  Created by Peter Choi on 2018. 1. 17..
//  Copyright © 2018년 Peter Choi. All rights reserved.
//
import UIKit
import os.log
import Alamofire
import Kanna

protocol MealParserDelegate: class {
    func onParseFinished(utf8data: String)
}

public class MealParser : SessionDelegate {
    
    public let RESPONSE_CODE_SUCCESS = 0
    public let RESPONSE_CODE_NIL_URL = 1
    
    public let CAT_KINDERGARTEN = "1"
    public let CAT_PRIMARY_SCHOOL = "2"
    public let CAT_JR_HIGH_SCHOOL = "3"
    public let CAT_HIGH_SCHOOL = "4"
    
    public let KIND_KINDERGARTEN = "01"
    public let KIND_PRIMARY_SCHOOL = "02"
    public let KIND_JR_HIGH_SCHOOL = "03"
    public let KIND_HIGH_SCHOOL = "04"
    
    public let MEAL_DATE = "0"
    public let MEAL_BREAKFAST = "1"
    public let MEAL_LUNCH = "2"
    public let MEAL_DINNER = "3"
    
    weak var delegate: MealParserDelegate?
    
//    func URLSession(session: URLSession, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        completionHandler(, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust))
//    }
    
    public func getMeal(cityCode: String, schoolCode: String, schoolCategoryCode: String, schoolKindCode: String, mealCode: String, year: String, month: String, day: String) -> [String?] {
        let url = "https://stu." + cityCode
            + "/sts_sci_md01_001.do?schulCode=" + schoolCode
            + "&schulCrseScCode=" + schoolCategoryCode + "&schulKndScCode="
            + schoolKindCode + "&schMmealScCode=" + mealCode
            + "&schYmd=" + year + "." + month + "." + day
        return getMealSub(urlString: url)
    }
    
    public func getMealNew(cityCode: String, schoolCode: String, schoolCategoryCode: String, schoolKindCode: String, mealCode: String, year: String, month: String, day: String) {
        let url = "https://stu." + cityCode
            + "/sts_sci_md01_001.do?schulCode=" + schoolCode
            + "&schulCrseScCode=" + schoolCategoryCode + "&schulKndScCode="
            + schoolKindCode + "&schMmealScCode=" + mealCode
            + "&schYmd=" + year + "." + month + "." + day
        getMealSubNew(urlString: url)
    }
    
    //TODO: 테스트 후 private으로 변경할 것
    private func getMealSubNew(urlString: String) {
        let url = URL(string: urlString)!
        let host = url.host!
        
        let serverTrustPolicies : [String: ServerTrustPolicy] = [
            host : ServerTrustPolicy.pinCertificates(
                certificates: ServerTrustPolicy.certificates(in: Bundle.main),
                validateCertificateChain: true,
                validateHost: true),
            "insecure.expired-apis.com" : .disableEvaluation
        ]
        
        let sessionManager = SessionManager(configuration: URLSessionConfiguration.default, delegate: self, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        sessionManager.request(url, method: HTTPMethod.get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json"])
            .validate(statusCode: 200..<300)
            .responseString(completionHandler: { (response) in
                if let result = response.result.value {
                    print(result)
                } else {
                    print("Alamofire.request == failed")
                }
            })
//            .responseJSON { (response) in
//                if let result = response.result.value {
//                    print(result)
//                } else {
//                    print("Alamofire.request == failed")
//                }
//        }
    }
    
    private func getMealSub(urlString: String) -> [String?] {
        let url = URL(string: urlString)!
        let data: Data = try! Data(contentsOf: url)
        
        var td = Array<String?>()
        let document = try? Kanna.HTML(html: data, encoding: .utf8)
        guard document != nil else {
            return [nil]
        }
        for td_data in document!.xpath("//td") {
            td.append(td_data.innerHTML?.replacingOccurrences(of: "<br>", with: "\n"))
        }
        
        var meal = Array<String?>()
        for i in 7..<13 {
            if i >= td.count {
                meal.append(nil)
            } else {
                if td[i] != nil {
                    meal.append(td[i]?.replacingOccurrences(of: "국내산", with: ""))
                }
            }
        }
        return meal
    }
    
    public func getDate(cityCode: String, schoolCode: String, schoolCategoryCode: String, schoolKindCode: String, year: String, month: String, day: String) -> [String?] {
        let url = "http://stu." + cityCode
            + "/sts_sci_md01_001.do?schulCode=" + schoolCode
            + "&schulCrseScCode=" + schoolCategoryCode + "&schulKndScCode="
            + schoolKindCode + "&schMmealScCode=" + MEAL_LUNCH
            + "&schYmd=" + year + "." + month + "." + day
        return getDateSub(urlString: url)
    }
    
    private func getDateSub(urlString: String) -> [String?] {
        let url = URL(string: urlString)!
        let data: Data = try! Data(contentsOf: url)
        
        var th = Array<String?>()
        let document = try? Kanna.HTML(html: data, encoding: .utf8)
        guard document != nil else {
            return [nil]
        }
        var index = 0
        for th_data in document!.xpath("//th") {
            if index == 0 {
                index+=1
                continue
            } else if index > 7 {
                break
            }
            th.append(th_data.text)
            index+=1
        }
        return th
    }
    
    public func saveMealData(data: [MealModel]) {
        let ud = UserDefaults(suiteName: "group.mealData")
        for d in data {
            ud?.set(d.date, forKey: getMealKeyScheme(dayOfWeek: d.dayOfWeek, mealOfDay: MEAL_DATE))
            ud?.set(d.breakfast, forKey: getMealKeyScheme(dayOfWeek: d.dayOfWeek, mealOfDay: MEAL_BREAKFAST))
            ud?.set(d.lunch, forKey: getMealKeyScheme(dayOfWeek: d.dayOfWeek, mealOfDay: MEAL_LUNCH))
            ud?.set(d.dinner, forKey: getMealKeyScheme(dayOfWeek: d.dayOfWeek, mealOfDay: MEAL_DINNER))
        }
        ud?.synchronize()
    }
    
    public func getMealKeyScheme(dayOfWeek: Int, mealOfDay: String) -> String {
        return String(dayOfWeek) + "-" + mealOfDay
    }
    
}

public class MealModel {
    var date: String?
    var breakfast: String?
    var lunch: String?
    var dinner: String?
    var dayOfWeek: Int = 0
    init(dayOfWeek: Int, date: String?, breakfast: String?, lunch: String?, dinner: String?) {
        self.date = date
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
        self.dayOfWeek = dayOfWeek
    }
}

