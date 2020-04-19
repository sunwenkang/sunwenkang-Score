//
//  WebVC.swift
//  Score
//
//  Created by 949699582 on 2020/3/10.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit
import WebKit
class WebVC: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let filePath:String! = Bundle.main.path(forResource: "Outstanding", ofType: "docx")
        
        let url = URL(fileURLWithPath: filePath)
        
        let request = NSURLRequest(url: url)
        
        webview.load(request as URLRequest)
        
    
        
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
