//
//  WebParser.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 5. 18..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import Foundation
import Kanna

protocol WebParserDelegate {
    func onSiteMapLoadFinished(siteMap: [SiteMapObject])
    func onTaskFinished(data: [WebObject]?)
}

class WebParser {
    
    private let siteMapUrl = "http://kanggo.net/sitemap.do"
    private var parseUrl = "http://kanggo.net/boardCnts/list.do?boardID=19202&m=0301&s=ganggo"
    
    private var delegate: WebParserDelegate?
    
    func parseDocument(url: String) {
        var data: [WebObject]? = nil
        DispatchQueue(label: "xyz.ridsoft.KanggoPocket.WebParser.document").async {
            data = self.parseDocumentSub(urlString: url)
            DispatchQueue.main.async {
                if self.delegate != nil {
                    self.delegate?.onTaskFinished(data: data)
                }
            }
        }
    }
    
    private func parseDocumentSub(urlString: String) -> [WebObject]? {
        guard let url = URL(string: urlString), let document = try? Kanna.HTML(url: url, encoding: .utf8) else {
            return nil
        }
        
        let tables = document.xpath("//table")
        
        var table: XMLElement?
        for t in tables {
            if t.className == "wb" {
                table = t
                break
            }
        }
        
        if table == nil {
            return nil
        }
        
        var scheme: [String] = []
        let thead = table!.xpath("//thead")[0]
        for e in thead.xpath("//th") {
            guard let td = e.content else {
                continue
            }
            scheme.append(td)
        }
        
        let tbody = table!.xpath("//tbody")[0]
        let tr = tbody.xpath("//tr")
        
        var webList: [WebObject] = []
        for e in tr {
            let webObject = WebObject()
            
            var i = 0
            for e1 in e.xpath("//td") {
                let data = e1.content == nil ? "" : e1.content!
                webObject.append(scheme: scheme[i], data: data)
                i += 1
            }
            var id = ""
            if var goView = e.xpath("//a")[0]["onclick"] {
                goView.remove(at: goView.index(before: goView.index(of: "(")!))
                goView.remove(at: goView.index(after: goView.index(of: ")")!))
                id = String(goView.split(separator: ",")[1])
                id.remove(at: id.index(before: id.index(of: "'")!))
                id.remove(at: id.index(after: id.index(of: "'")!))
            }
            webList.append(webObject)
        }
        
        return webList
    }
    
    func parseSiteMap() {
        var data: [SiteMapObject] = []
        DispatchQueue(label: "xyz.ridsoft.KanggoPocket.WebParser.sitemap").async {
            data = self.parseSiteMapSub()
                DispatchQueue.main.async {
                    if self.delegate != nil {
                        self.delegate?.onSiteMapLoadFinished(siteMap: data)
                    }
            }
        }
    }
    
    private func parseSiteMapSub() -> [SiteMapObject] {
        return []
    }
    
}

class SiteMapObject {
    var title: String
    var id: String
    init(title: String, id: String) {
        self.title = title
        self.id = id
    }
}

class WebObject {
    var title: String = ""
    var date: String = ""
    var writer: String = ""
    var viewCount: String = ""
    var id: String = ""
    
    func append(scheme: String, data: String) {
        switch scheme {
        case "제목":
            title = data
            break
            
        case "작성자":
            writer = data
            break
            
        case "조회수":
            viewCount = data
            break
            
        case "작성일":
            date = data
            break
            
        default:
            break
        }
    }
}

