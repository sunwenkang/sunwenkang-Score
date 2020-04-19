//
//  ScoreVC.swift
//  Score
//
//  Created by 949699582 on 2020/2/21.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var groupArrayCount = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // group count
        let path:String! = Bundle.main.path(forResource: "SData", ofType: "plist")
        let groupArray:NSArray! = NSArray(contentsOfFile: path)
        groupArrayCount = groupArray.count
        
        // MARK: - random number
    
//        let count = UInt32(groupArray.count - 1)
//
//        let i:UInt32 = 2
//        var x = UInt32(arc4random() % count)
//
//        var workFlag = "0"
//        if i == x {
//
//            while i == x {
//                x = arc4random() % 4
//
//                workFlag = x.description
//            }
//
//        }else{
//            workFlag = x.description
//        }
//        print(workFlag)
        
        // other user group
        // get next work
        let curruentUser = SingleStudent.sharedInstance
        
        print(curruentUser.groupId)
        
        var xx = 0
        
        if curruentUser.groupId == (groupArray.count-1).description {
            xx = 0
        }else{
            xx = (Int(curruentUser.groupId) ?? 0) + 1
        }
        
        
        let userDefault = UserDefaults.standard
        let imageString = userDefault.object(forKey: xx.description + "image")
        
        if imageString == nil {
            let image2 = UIImage(named: "bitmap")
            img.image = image2
        }else{
            //  base64 Img transto Data
            let decodedData = NSData(base64Encoded:imageString as! String, options:NSData.Base64DecodingOptions())
            //  Data trans to Image
            let image2 = UIImage(data: decodedData! as Data)
            img.image = image2
        }
        
        
        
    }
    
    
    @IBAction func scoreAction(_ sender: UIButton) {
        
        // Save score
        if textField.text?.count == 0 {
            print("分数不能为空")
            
        }else{
            
            let curruentUser = SingleStudent.sharedInstance
            
            let userDefault = UserDefaults.standard
            
            if userDefault.object(forKey: "have" + curruentUser.userid.description) as! String == "0" {
                userDefault.set("1", forKey: "have" + curruentUser.userid.description)
                
                if userDefault.object(forKey: "score" + curruentUser.groupId.description) == nil {
                    print("无之前暂无评分")
                    
                    
                    var nextGroupWork = 0
                    if Int(curruentUser.groupId) == groupArrayCount {
                        nextGroupWork = 0
                    }else{
                        nextGroupWork = (Int(curruentUser.groupId) ?? 0) + 1
                    }
                    
                    userDefault.set(textField.text, forKey: "score" + nextGroupWork.description)
                    userDefault.synchronize()
                    
                    // push to ScoreSuccessVC
                    let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
                    let deskVC:ScoreSuccessVC! = storyBoard!.instantiateViewController(withIdentifier: "ScoreSuccessVC") as? ScoreSuccessVC
                    self.navigationController?.pushViewController(deskVC, animated: true)
                }else{
                    
                    
                    let score:String = userDefault.object(forKey: "score" + curruentUser.groupId.description) as! String
                    
                    print("score = " + score)
                    
                    let scoreSave1:Int = Int(score) ?? 1
                    let scoreSave2:Int = Int(textField.text!) ?? 1
                    
                    let scoreSave = scoreSave1 + scoreSave2
                    
                    print(scoreSave);
                    
                    
                    userDefault.set(scoreSave.description, forKey: "score" + curruentUser.groupId.description)
                    userDefault.synchronize()
                    
                    
                    // push to ScoreSuccessVC
                    let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
                    let deskVC:ScoreSuccessVC! = storyBoard!.instantiateViewController(withIdentifier: "ScoreSuccessVC") as? ScoreSuccessVC
                    self.navigationController?.pushViewController(deskVC, animated: true)
                }
            }else{
                print("已评分,无法再次评分");
                
                let alertController = UIAlertController(title: "Alert",
                                message: "You have give a score,can not operate agagin", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    print("点击了确定")
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    
}
