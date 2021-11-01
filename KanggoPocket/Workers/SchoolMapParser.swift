//
//  SchoolMapParser.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 5. 4..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//

import Foundation
import Kanna

class SchoolMapParser {
    
    let url = "http://kanggo.net/sub/info.do?m=0110&s=ganggo"

    func getImageUrl() -> String? {
        guard let apiURL = URL(string: url) else { return nil }
        guard let apiData = try? Data(contentsOf: apiURL) else { return nil }
        
        guard let subContentDocument = try? Kanna.HTML(html: apiData, encoding: .utf8) else { return nil }
        let img = subContentDocument.xpath("//*[@id=\"all-scroll\"]/div/p[1]/img")[0]
        
        if img["src"] == nil {
            return nil
        }
        
        let imgUrl = "http://kanggo.net" + img["src"]!

        return imgUrl
    }
    
    func getMapImage(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
    
}
