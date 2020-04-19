//
//  StudentFuncVC.swift
//  Score
//
//  Created by 949699582 on 2020/2/18.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class StudentFuncVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let curruentUser = SingleStudent.sharedInstance
        print(curruentUser.groupId)
        
//        let userDefault = UserDefaults.standard
//        let name = userDefault.object(forKey: "name") as? String
//        
//        print(name)
        
    }
    
    // touch upload action
    @IBAction func uploadAction(_ sender: UIButton) {
        
    }
    
    // touch score action
    @IBAction func scoreAction(_ sender: UIButton) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
