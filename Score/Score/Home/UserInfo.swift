//
//  UserInfo.swift
//  Swift-自动归档
//
//  Created by 李含文 on 2019/8/6.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

import UIKit


@objcMembers class UserInfo: NSObject, NSCoding, HWMappable {
    var id: Int = 0 // 用户id
    var name: String = ""
    var phone: String = ""
    var age = 0
    /// json转模型
    class func jsonToUser(_ json:String) -> UserInfo? {
        let user = try? UserInfo.hw_mapFromJson(json, UserInfo.self)
        return user
    }

    // MARK: - 归档
    func encode(with aCoder: NSCoder) {
        UserTool.removeUser() // 归档前先删除原来的 避免错误
        for name in getAllPropertys() {
            guard let value = self.value(forKey: name) else {
                return
            }
            aCoder.encode(value, forKey: name)
        }
    }
    // MARK: - 解档
    internal required init?(coder aDecoder: NSCoder){
        super.init()
        for name in getAllPropertys() {
            guard let value = aDecoder.decodeObject(forKey: name) else {
                return
            }
            setValue(value, forKeyPath: name)
        }
    }
    // MARK: - 获取属性数组
    func getAllPropertys() -> [String] {
        var count: UInt32 = 0 // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        let properties = class_copyPropertyList(self.classForCoder, &count)
        var propertyNames: [String] = []
        for i in 0..<Int(count) { // Swift中类型是严格检查的，必须转换成同一类型
            if let property = properties?[i] { // UnsafeMutablePointer<objc_property_t>是可变指针，因此properties就是类似数组一样，可以通过下标获取
                let name = property_getName(property)
                // 这里还得转换成字符串
                let strName = String(cString: name)
                propertyNames.append(strName)
            }
        }
        // 不要忘记释放内存，否则C语言的指针很容易成野指针的
        free(properties)
        return propertyNames
    }
    // MARK: - 获取对应属性的值 没有侧返回nil
    func getValueOfProperty(property:String) -> AnyObject? {
        let allPropertys = self.getAllPropertys()
        if (allPropertys.contains(property)) {
            return self.value(forKey: property) as AnyObject
        }else{
            return nil
        }
    }
}


enum HWMapError: Error {
    case jsonToModelFail    //json转model失败
    case jsonToDataFail     //json转data失败
//    case dictToJsonFail     //字典转json失败
//    case jsonToArrFail      //json转数组失败
//    case modelToJsonFail    //model转json失败
}

public protocol HWMappable: Codable {
    func hw_modelMapFinished()
    mutating func hw_structMapFinished()
}
extension HWMappable {
    public func hw_modelMapFinished() {
        //外部自己实现
    }
    public mutating func hw_structMapFinished() {
        //外部自己实现
    }
//    ///字典转模型
//    public static func hw_mapFromDict<T : HWMappable>(_ dict : [String:Any], _ type:T.Type) throws -> T {
//        guard let JSONString = dict.hw_toJSONString() else {
//            throw HWMapError.dictToJsonFail
//        }
//        guard let jsonData = JSONString.data(using: .utf8) else {
//            throw HWMapError.jsonToDataFail
//        }
//        let decoder = JSONDecoder()
//        do {
//            let obj = try decoder.decode(type, from: jsonData)
//            var vobj = obj
//            let mirro = Mirror(reflecting: vobj)
//            if mirro.displayStyle == Mirror.DisplayStyle.struct {
//                vobj.hw_structMapFinished()
//            }
//            if mirro.displayStyle == Mirror.DisplayStyle.class {
//                vobj.hw_modelMapFinished()
//            }
//            return vobj
//        }catch {
//            print(error)
//        }
//        throw HWMapError.jsonToModelFail
//    }
    
    ///JSON转模型
    static func hw_mapFromJson<T : HWMappable>(_ JSONString : String, _ type:T.Type) throws -> T {
        guard let jsonData = JSONString.data(using: .utf8) else {
            throw HWMapError.jsonToDataFail
        }
        let decoder = JSONDecoder()
        do {
            let obj = try decoder.decode(type, from: jsonData)
            var vobj = obj
            let mirro = Mirror(reflecting: vobj)
            if mirro.displayStyle == Mirror.DisplayStyle.struct {
                vobj.hw_structMapFinished()
            }
            if mirro.displayStyle == Mirror.DisplayStyle.class {
                vobj.hw_modelMapFinished()
            }
            return vobj
        } catch {
            print(error)
        }
        throw HWMapError.jsonToModelFail
    }
    
//    ///模型转字典
//    public func hw_ToDict() -> [String:Any] {
//        let mirro = Mirror(reflecting: self)
//        var dict = [String:Any]()
//        for case let (key?, value) in mirro.children {
//            dict[key] = value
//        }
//        return dict
//    }
//
//    ///模型转json字符串
//    public func hw_ToJSON() throws -> String {
//        if let str = self.hw_ToDict().hw_toJSONString() {
//            return str
//        }
//        print(HWMapError.modelToJsonFail)
//        throw HWMapError.modelToJsonFail
//    }
}

class UserTool {
    // MARK: - 归档路径设置
    static private var Path: String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent("account.plist")
    }

    /// 是否登录
    static func isLogin() -> Bool {
        guard UserTool.getUser() != nil else {
            return false  //文件不存在
        }
        return true
    }
    /// 存档
    static func saveUser(_ json: String) {
        guard let user = UserInfo.jsonToUser(json) else {
            return
        }
        NSKeyedArchiver.archiveRootObject(user, toFile: Path)
    }
    /// 获取用户信息
    static func getUser()-> UserInfo? {
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: Path) as? UserInfo
        return user
    }
    /// 删档
    static func removeUser() {
        if FileManager.default.fileExists(atPath: Path) {
            try! FileManager.default.removeItem(atPath: Path) // 删除文件
        }else{

        }
    }
}

// MARK: - 字典转json
extension Dictionary {
    public func hw_toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("dict转json失败")
            return nil
        }
        if let newData : Data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            let JSONString = NSString(data:newData as Data,encoding: String.Encoding.utf8.rawValue)
            return JSONString as String? ?? nil
        }
        print("dict转json失败")
        return nil
    }
}
// MARK: - json转字典
extension String {
    func hw_toDictionary() -> NSDictionary? {
        guard let jsonData:Data = self.data(using: .utf8) else {
            return nil
        }
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as? NSDictionary
        }
        return nil
    }
}
