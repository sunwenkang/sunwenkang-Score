//
//  ViewController.swift
//  Score
//
//  Created by 949699582 on 2020/2/18.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnS: UIButton!
    @IBOutlet weak var btnT: UIButton!
    
    @IBOutlet weak var img_n: UIImageView!
    @IBOutlet weak var img_y: UIImageView!
    
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    // identification flag 0:student 1:teacher 2:null
    var role = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
    }
    
    // touch login button action
    @IBAction func loginAction(_ sender: UIButton) {
        
        self.checkData()
//
        // get Plist file path
        let path:String! = Bundle.main.path(forResource: "SData", ofType: "plist")
        let groupArray:NSArray! = NSArray(contentsOfFile: path)

        var flag = 0
        
        if role == 0 {
            // check student
                    for  member in groupArray {

                        let studentM:NSDictionary! = member as! NSDictionary

                        let studentArray:NSArray! = studentM["member"] as! NSArray

                        for stu in studentArray{

                            print(stu)

                            let student:NSDictionary = stu as! NSDictionary

                            if numberField.text == student["number"] as! String && passwordField.text == student["password"] as? String{
                                print("success")
                                flag = 1

                                let curruentUser = SingleStudent.sharedInstance
                                curruentUser.name = numberField.text ?? ""
                                curruentUser.groupId = studentM["id"] as! String
                                curruentUser.userid = student["userID"] as! String
                                
                                // save init user scoro info
                                let userDefault = UserDefaults.standard
                                userDefault.set("0", forKey: "have" + curruentUser.userid.description)

                                let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            //
                                let deskVC:StudentFuncVC! = storyBoard!.instantiateViewController(withIdentifier: "StudentFuncVC") as? StudentFuncVC
                                self.navigationController?.pushViewController(deskVC, animated: true)
                                break
                            }
                        }
                    }

                    if flag == 0 {
                        let alertController = UIAlertController(title: "Alert",
                                        message: "You are not belong to our school", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                            action in
                            print("yes")
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
        }else if role == 1{
            
            // get Plist file path
            let path:String! = Bundle.main.path(forResource: "TPlist", ofType: "plist")
            let tDict:NSDictionary! = NSDictionary(contentsOfFile: path)
            
            if tDict["number"] as! String == numberField.text && tDict["password"] as! String == passwordField.text{
                print("information right")
                
                let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)

                let deskVC:TeacherVC = storyBoard!.instantiateViewController(withIdentifier: "TeacherVC") as! TeacherVC
                self.navigationController?.pushViewController(deskVC, animated: true)
            }else{
                
                let alertController = UIAlertController(title: "Alert",
                                message: "You are not a teacher", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    print("yes")
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            
        }
        
//
        
    }
    
    // choose S role
    @IBAction func btnSAction(_ sender: UIButton) {
        
        img_n.image = UIImage(named: "xuanze_y")
        img_y.image = UIImage(named: "xuanze_n")
        
        self.role = 0
        
    }
    
    // choose T role
    @IBAction func btnTAction(_ sender: UIButton) {
        img_n.image = UIImage(named: "xuanze_n")
        img_y.image = UIImage(named: "xuanze_y")
        
        self.role = 1
    }
    
    // toucu window Pack up keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // prevent nil
    func checkData() {
        
        if role == 2 {
            let alertController = UIAlertController(title: "Alert",
                            message: "Role Can Not Be Null", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                print("yes")
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if numberField.text?.count != 9{
            let alertController = UIAlertController(title: "Alert",
                            message: "The number has to be nine", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                print("yes")
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else if passwordField.text?.count == 0{
            let alertController = UIAlertController(title: "Alert",
                            message: "The pssword can not be null", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                print("yes")
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

