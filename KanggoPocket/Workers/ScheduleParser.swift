//
//  ScheduleParser.swift
//  KanggoPocket
//
//  Created by Peter Choi on 2018. 1. 3..
//  Copyright © 2018년 RiDsoft. All rights reserved.
//
import UIKit
import Kanna
import Alamofire

class ScheduleParser {
    
    var url: String = "https://docs.google.com/spreadsheets/d/1C0fNkDZce6W4bMjee0AMGS8yfMMv_h-uTX6yhBhb5qc/pubhtml?gid=0&single=true"
    let newURL = "https://docs.google.com/spreadsheets/d/e/2PACX-1vTwqkcmlYXVK7vk9CFlzybOt3rGMvH4nZl-F6_17J0sOpupucyVNCmS9vpogyyJDkm8ePbV3-hvKpqg/pubhtml"
    
    public var classNum = Array<Int>()
    
    func doParse() -> [ScheduleModel]? {
        let apiURL = URL(string: url)
        let apiData = try! Data(contentsOf: apiURL!)
        var scheduleData = Array<String>()
        var teacherData = Array<String>()
        var first = 0, second = 0, third = 0
        var classNumberData = Array<Int>()
        
        var td = Array<String>()
        let document = try? Kanna.HTML(html: apiData, encoding: .utf8)
        guard document != nil else {
            return nil
        }
        for docData in document!.xpath("//td") {
            td.append(docData.text!)
        }
        var totalCount: Int = 30
        var count: Int = 0
        var mode: Int = 0 //0은 시간표, 1은 선생님
        for data in td {
            count+=1
            if data.contains("-") {
                //학년별 반의 개수 올리기
                let grade = Int(data.split(separator: "-")[0])!
                let classNum = Int(data.split(separator: "-")[1])!
                switch grade {
                case 1: first = classNum
                    break
                case 2: second = classNum
                    break
                case 3: third = classNum
                    break
                default: break
                }
                totalCount = 31
                mode = 0
            } else {
                if count <= totalCount {
                    if mode == 0 {
                        scheduleData.append(data)
                        if count >= 31 {
                            mode = 1
                            count = 0
                        }
                    } else {
                        teacherData.append(data)
                        if count >= 30 {
                            mode = 0
                            count = 0
                            totalCount = 30
                        }
                    }
                }
            }
        }
        classNumberData.append(first)
        classNumberData.append(second)
        classNumberData.append(third)
        
        var data = Array<ScheduleModel>()
        var index = 0
        for i in 0..<3 {
            for j in 0..<classNumberData[i] {
                for k in 0..<5 {
                    var schedule = ""
                    for l in 0..<6 {
                        let s: String = String(l + 1) + NSLocalizedString("schedule_data_class_number", comment: "schedule_data_class_number")
                        let s1: String = scheduleData[index] + " (" + teacherData[index] + ")"
                        if l == 0 {
                            schedule += s + s1
                        } else {
                            schedule += "\n\n" + s + s1
                        }
                        index+=1
                    }
                    data.append(ScheduleModel(g: i + 1, c: j + 1, d: k, s: schedule))
                }
            }
        }
        classNum = classNumberData
        return data
    }
    
    func clearScheduleData() {
        let grade = 3
        for i in 1...grade {
            for j in 1...10 {
                if UserDefaults.standard.object(forKey: String(i) + "-" + String(j) + "-0") != nil {
                    for k in 0..<5 {
                        let key = String(i) + "-" + String(j) + "-" + String(k)
                        UserDefaults.standard.removeObject(forKey: key)
                    }
                }
            }
        }
    }
    
    func saveData(classNum: [Int], data: [ScheduleModel]) {
        let userDefaults = UserDefaults(suiteName: "group.scheduleData")!
        for d in data {
            let key = String(d.grade) + "-" + String(d.classNum) + "-" + String(d.dayOfWeek)
            userDefaults.set(d.schedule, forKey: key)
        }
        userDefaults.set(classNum[0], forKey: UserDefaultsKeys().INT_1ST_GRADE_CLASS_NUM)
        userDefaults.set(classNum[1], forKey: UserDefaultsKeys().INT_2ND_GRADE_CLASS_NUM)
        userDefaults.set(classNum[2], forKey: UserDefaultsKeys().INT_3RD_GRADE_CLASS_NUM)
        userDefaults.synchronize()
    }
    
    func parseSchedule() -> [ScheduleModel]? {
        let apiURL = URL(string: newURL)
        let apiData = try! Data(contentsOf: apiURL!)
        var first = 0, second = 0, third = 0
        var classNumberData = Array<Int>()
        
        var td = Array<String>()
        let document = try? Kanna.HTML(html: apiData, encoding: .utf8)
        guard document != nil else {
            return nil
        }
        for data in document!.xpath("//td") {
            td.append(data.text!)
        }
        
        var schematic = [1, 1, 1, 1, 1]
        var prev = 0
        var indexOfSchematic = 0
        var switched = false
        for t in td {
            if switched {
                let curr = Int(t)
                if curr != nil {
                    if prev < curr! {
                        prev = curr!
                        schematic[indexOfSchematic]+=1
                    } else {
                        prev = 0
                        indexOfSchematic+=1
                    }
                }
            } else {
                if t == "1" {
                    switched = true
                }
            }
        }
        print(schematic[0], schematic[1], schematic[2], schematic[3], schematic[4])
        
        var startIndex = 0
        for i in td.indices {
            if td[i] == "1-1" {
                startIndex = i
                break
            }
        }
        
        var processedTd = Array<String>()
        for i in startIndex..<td.count {
            processedTd.append(td[i])
        }
        var scheduleData = Array<String>()
        var teacherData = Array<String>()
        
        var totalCountOfSchedule = 1
        var totalCountOfTeacher = 0
        for i in schematic {
            totalCountOfSchedule += i
            totalCountOfTeacher += i
        }
        var count: Int = 0
        var mode: Int = 0 //0은 시간표, 1은 선생님
        for data in processedTd {
            count+=1
            if data.contains("-") {
                //학년별 반의 개수 올리기
                let grade = Int(data.split(separator: "-")[0])!
                let classNum = Int(data.split(separator: "-")[1])!
                switch grade {
                case 1: first = classNum
                    break
                case 2: second = classNum
                    break
                case 3: third = classNum
                    break
                default: break
                }
                mode = 0
            } else {
                if count <= totalCountOfSchedule {
                    if mode == 0 {
                        scheduleData.append(data)
                        if count >= totalCountOfSchedule {
                            mode = 1
                            count = 0
                        }
                    } else {
                        teacherData.append(data)
                        if count >= totalCountOfTeacher {
                            mode = 0
                            count = 0
                        }
                    }
                }
            }
        }
        classNumberData.append(first)
        classNumberData.append(second)
        classNumberData.append(third)
        
        var data = Array<ScheduleModel>()
        var index = 0
        for i in 0..<3 {
            for j in 0..<classNumberData[i] {
                for k in 0..<5 {
                    var schedule = ""
                    for l in 1...schematic[k] {
                        if l != 1 {
                            schedule += "\n\n"
                        }
                        let scheduleString = scheduleData[index]
                        let teacherString = teacherData[index]
                        let s = String(l) + "교시: "
                        let s1 = teacherString == "" ? "없음" : scheduleString + " (" + teacherString + ")"
                        schedule += s + s1
                        index+=1
                    }
                    data.append(ScheduleModel(g: i + 1, c: j + 1, d: k, s: schedule))
                }
            }
        }
        classNum = classNumberData
        return data
    }
}

class ScheduleModel {
    var grade: Int = 0
    var classNum: Int = 0
    var dayOfWeek: Int = 0 // 0 -> "mon", ..., 4 -> "fri"
    var schedule: String = ""
    init(g: Int, c: Int, d: Int, s: String) {
        grade = g
        classNum = c
        dayOfWeek = d
        schedule = s
    }
}



