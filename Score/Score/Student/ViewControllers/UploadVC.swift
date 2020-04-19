//
//  UploadVC.swift
//  Score
//
//  Created by 949699582 on 2020/2/18.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var img_upload: UIImageView!
    var takingPicture:UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // img gesture
        let uploadTap = UITapGestureRecognizer.init(target: self, action: #selector(pickimgAction))
        img_upload.addGestureRecognizer(uploadTap)
        
    }
    
    // uploadImg
    @IBAction func uploadAction(_ sender: UIButton) {
        
        let curruentUser = SingleStudent.sharedInstance
        print(curruentUser.groupId)
        
        let image:UIImage! = img_upload.image
        let imgData = image.pngData();

        let userDefault = UserDefaults.standard
        userDefault.set(imgData?.base64EncodedString(), forKey: curruentUser.groupId.description + "image")
        userDefault.synchronize()
        
        print("success");
        
        
        
    }
    
    // start pick img
    @objc func pickimgAction(){
        let actionSheetController = UIAlertController()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alertAction) -> Void in
            print("Tap cancel Button")
        }
        
        let takingPicturesAction = UIAlertAction(title: "photograph", style: UIAlertAction.Style.destructive) { (alertAction) -> Void in
            self.getImageGo(type: 1)
        }
        
        let photoAlbumAction = UIAlertAction(title: "album", style: UIAlertAction.Style.default) { (alertAction) -> Void in
            self.getImageGo(type: 2)
        }
        
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(takingPicturesAction)
        actionSheetController.addAction(photoAlbumAction)
        
        
        // show
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    // pick way
    func getImageGo(type:Int){
        takingPicture =  UIImagePickerController.init()
        if(type==1){
            takingPicture.sourceType = .camera
            
            //takingPicture.showsCameraControls = true
        }else if(type==2){
            takingPicture.sourceType = .photoLibrary
        }
        takingPicture.allowsEditing = false
        takingPicture.delegate = self
        present(takingPicture, animated: true, completion: nil)
    }
    
    
    
    // pick callback
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        takingPicture.dismiss(animated: true, completion: nil)
        if(takingPicture.allowsEditing == false){
            // origin
            img_upload.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }else{
            // cut
            img_upload.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        }
        
    }
    
    
}
