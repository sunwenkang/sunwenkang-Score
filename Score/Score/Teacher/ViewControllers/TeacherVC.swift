//
//  TeacherVC.swift
//  Score
//
//  Created by 949699582 on 2020/2/21.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class TeacherVC: UITableViewController {
    
    var groupArrayCount = 0
    var worksArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let path:String! = Bundle.main.path(forResource: "SData", ofType: "plist")
        let groupArray:NSArray! = NSArray(contentsOfFile: path)
        groupArrayCount = groupArray.count
        
        let curruentUser = SingleStudent.sharedInstance
        print(curruentUser.groupId)
        
        
        var flag = 0
        for index in 0 ..< groupArrayCount{
            
            
            let userDefault = UserDefaults.standard
            let imageString = userDefault.object(forKey: flag.description + "image")
            flag = flag + 1
            
            if imageString != nil {
                worksArray.append(imageString as! String)
            }else{
                worksArray.append("")
            }
            
        }
        
        self.tableView.register(UINib(nibName: "TCell", bundle: nil), forCellReuseIdentifier: "TCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupArrayCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TCell = tableView.dequeueReusableCell(withIdentifier: "TCell", for: indexPath) as! TCell
        
        //  base64 img trans to Data
        if worksArray[indexPath.row] == ""{
            let image2 = UIImage(named: "bitmap")
            cell.imgV.image = image2
        }else{
            let decodedData = NSData(base64Encoded:worksArray[indexPath.row] as! String, options:NSData.Base64DecodingOptions())
            //        // Data trans to image
            let image2 = UIImage(data: decodedData! as Data)
            cell.imgV.image = image2
        }
        
        
        cell.nameLB.text = "Group" + String(indexPath.row)
        
        let userDefault = UserDefaults.standard
        
        if userDefault.object(forKey: "score" + indexPath.row.description) as? String == nil {
            cell.scoreLB.text = "No Score"
        }else{
            let score:String = userDefault.object(forKey: "score" + indexPath.row.description) as! String
            cell.scoreLB.text = score
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        var deskVC:TDetailVC = storyBoard!.instantiateViewController(withIdentifier: "TDetailVC") as! TDetailVC
        
        deskVC.indexFlag = indexPath.row
        
        self.navigationController?.pushViewController(deskVC, animated: true)
    }
    
    
}
