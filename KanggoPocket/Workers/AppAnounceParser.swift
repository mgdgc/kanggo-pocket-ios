//
//  AppAnounceParser.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 4. 12..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import Foundation
import Kanna

class AppAnnounceParser {
    
    var url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRhX8Vdu_iN6GZY0KcZOtz8PU0zFljQaHLRSX39SPOlRj5peNkdzMoC-55yBWhOBanJ6rhK0DUwfkUr/pubhtml"
    
    let allowedAttrs = ["id", "date", "title", "message", "image", "link"]
    
    func setCustomURL(url: String?) {
        if (url != nil) {
            self.url = url!
        }
    }
    
    func getData() -> [AppAnnounceModel] {
        let announceData = getAnnounceData()
        if announceData == nil {
            print("--------------------------------------")
            print("announceData is nil")
            return []
        } else {
            return convertToAppAnnounceModel(data: announceData!)
        }
    }
    
    func getAnnounceData() -> [Dictionary<String, String>]? {
        let apiURL = URL(string: url)
        let apiData = try! Data(contentsOf: apiURL!)
        
        guard let document = try? Kanna.HTML(html: apiData, encoding: .utf8) else {
            return nil
        }
        
        var scheme = Array<String>()
        var tds = Array<String>()
        for td in document.xpath("//td") {
            guard let content = td.content else {
                continue
            }
            if allowedAttrs.contains(content) {
                scheme.append(content)
            } else {
                tds.append(content)
            }
        }
        
        var result = [[String: String]]()
        var model = [String: String]()
        var indexOfTd = 0
        var indexOfScheme = 0
        for td in tds {
            if indexOfTd >= scheme.count {
                model[scheme[indexOfScheme]] = td
            }
            indexOfTd+=1
            indexOfScheme+=1
            if indexOfScheme >= scheme.count {
                indexOfScheme = 0
                result.append(model)
            }
        }
        
        return result
    }
    
    func convertToAppAnnounceModel(data: [Dictionary<String, String>]) -> [AppAnnounceModel] {
        var result = Array<AppAnnounceModel>()
        for d in data {
            if d["date"] == nil || d["id"] == nil || d["title"] == nil || d["message"] == nil {
//                print("--------------------------------------")
//                print("convertToAppAnnounceModel: some data are nil")
                continue
            } else {
                result.append(AppAnnounceModel.init(date: d["date"]!, id: d["id"]!, title: d["title"]!, content: d["message"]!, img: d["image"], action: d["link"]))
            }
        }
        return result
    }
    
}

class AppAnnounceModel {
    var date = ""
    var id = ""
    var title = ""
    var content = ""
    var img: String? = nil
    var action: String? = nil
    init (date: String, id: String, title: String, content: String, img: String?, action: String?) {
        self.date = date
        self.id = id
        self.title = title
        self.content = content
        self.img = img
        self.action = action
    }
}
