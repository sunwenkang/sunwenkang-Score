//
//  TDetailVC.swift
//  Score
//
//  Created by 949699582 on 2020/2/27.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class TDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    public var indexFlag = 0
    var studentArray = [NSDictionary]()
    
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Detail"
        
        print(indexFlag)
        
        self.tableview.register(UINib(nibName: "T_SCell", bundle: nil), forCellReuseIdentifier: "T_SCell")
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        let path:String! = Bundle.main.path(forResource: "SData", ofType: "plist")
        let groupArray:NSArray! = NSArray(contentsOfFile: path)
        
        let studentM:NSDictionary! = groupArray?[indexFlag] as! NSDictionary
        studentArray = (studentM["member"] as! NSArray) as! [NSDictionary]
        
        
        //  get the Comment
        let userDefault = UserDefaults.standard
        if userDefault.object(forKey: "content" + indexFlag.description) != nil {
            let contentString:String? = userDefault.object(forKey: "content" + indexFlag.description) as! String
            
            if contentString != nil {
                textview.text = contentString
            }
        }
        
        
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        
        let userDefault = UserDefaults.standard
        userDefault.set(textview.text, forKey: "content"+indexFlag.description)
        userDefault.synchronize()
        
        let alertController = UIAlertController(title: "Alert",
                        message: "Save success", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            print("success")
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:T_SCell = tableView.dequeueReusableCell(withIdentifier: "T_SCell", for: indexPath) as! T_SCell
        
        let student = studentArray[indexPath.row]
        
        cell.s_nameLB.text = student["name"] as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
