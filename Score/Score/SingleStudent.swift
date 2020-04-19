//
//  SingleStudent.swift
//  Score
//
//  Created by 949699582 on 2020/2/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit


let  single = SingleStudent()



class SingleStudent: NSObject {

    var groupId = ""
    var name = ""
    var number = ""
    var password = ""
    var userid = ""
    
    class var sharedInstance : SingleStudent {
        return single
    }
}
