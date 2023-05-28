//
//  UserSettings.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/28.
//

import SwiftUI

//  用户设置类 [单例模式]
class UserSettings :ObservableObject{
    static let shared = UserSettings()  //  唯一单例
    let userDefaults = UserDefaults.standard
    
    //   变量声明,加入监视器同步更新
    @Published var sportUnits: Int{  //  运动单位(min)
        didSet{
            userDefaults.set(sportUnits, forKey: "sportUnits")
        }
    }
    @Published var ring: String{       //  响铃设置
        didSet{
            userDefaults.set(ring, forKey: "ring")
        }
    }
    @Published var plan: Int{       //  运动计划(天)
        didSet{
            userDefaults.set(plan, forKey: "plan")
        }
    }
    @Published var id: String{   // 用户id
        didSet{
            userDefaults.set(id, forKey: "id")
        }
    }
    @Published var notLogin: Bool{  //  在线态,用来跳过注册登录界面 [true未登入:false登入]
        didSet{
            userDefaults.set(notLogin, forKey: "notLogin")
        }
    }
    @Published var signIn = true    //  登录态,用以指示“注册”和“登录”两个页面的切换 [true注册:false:登录]
    
    //  默认设置
    let defaults: [String: Any] = [
        "notLogin": true,
        "sportUnits": 1,
        "ring": "Music1",
        "plan": 1,
        "id": "用户名"
    ]
    //  读取设置初始化
    private init() {
        userDefaults.register(defaults: defaults)
        //  同步设置
        sportUnits = Int(userDefaults.integer(forKey: "sportUnits"))
        ring = userDefaults.string(forKey: "ring")!
        plan = Int(userDefaults.integer(forKey: "plan"))
        id = userDefaults.string(forKey: "id")!
        notLogin = userDefaults.bool(forKey: "notLogin")
    }
    
}
