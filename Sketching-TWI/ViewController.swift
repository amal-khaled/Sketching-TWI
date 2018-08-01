//
//  ViewController.swift
//  Sketching-TWI
//
//  Created by Amal Khaled on 7/31/18.
//  Copyright © 2018 TWI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var drawingView: DrawView!
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func redoTaped(_ sender: Any) {
        guard let lastElement = drawingView.undoList.popLast() else {return}
        drawingView.shapes.append( lastElement)
        drawingView.setNeedsDisplay()
    }
    @IBAction func undoTapped(_ sender: Any) {
        guard let lastElement =  drawingView.shapes.popLast() else {return}
        drawingView.undoList.append( lastElement)
        drawingView.setNeedsDisplay()

    }
    @IBAction func saveAsImageTapped(_ sender: Any) {
        let image = drawingView.getImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        createDialoge(msg: "Saved")
       
    }
    @IBAction func newTapped(_ sender: Any) {
        group.enter()
        DispatchQueue.main.async {
            self.clearChangesDialoge()
            
        }
        group.notify(queue: .main) {

            self.drawingView.shapes = []
            self.drawingView.backgroundColor = UIColor.white
            self.drawingView.setNeedsDisplay()
        }
    }
    @IBAction func uploadImageTapped(_ sender: Any) {
        
        //ask to save exist image
        group.enter()
        DispatchQueue.main.async {
            self.clearChangesDialoge()

        }
        //choose to upload using cam or lib
        group.notify(queue: .main) {
            let alert = UIAlertController(title: "", message: "Upload your image", preferredStyle: UIAlertControllerStyle.actionSheet)
            let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (alert) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera;
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            let lib = UIAlertAction(title: "Library", style: UIAlertActionStyle.default) { (alert) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary;
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alert) -> Void in
              
            }

            alert.addAction(camera)
            alert.addAction(lib)
            alert.addAction(cancelButton)
           
            self.present(alert, animated: true, completion: nil)
        
        }
    }
}

// helping methods
extension ViewController{
    
    //Alert with custom msg and specific time (without action)
    func createDialoge(msg: String){
        let alert = UIAlertController(title: "" , message: msg, preferredStyle: .alert)
        self.present(alert, animated: true)

        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }

    }
    
    //Alert to save image before deleting it
    func clearChangesDialoge(){
        if drawingView.shapes.count != 0 {
            let alert = UIAlertController(title: "do you want to Save changes?" , message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                let image = self.drawingView.getImage()
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.group.leave()
            }))

            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
                self.group.leave()
            }))
            self.present(alert, animated: true)
        }
        else{
            self.group.leave()

        }
    }
    
}
extension ViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        drawingView.shapes = []
        
       if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
        UIGraphicsBeginImageContext(drawingView.frame.size)
        image.draw(in: self.drawingView.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        drawingView.backgroundColor = UIColor.init(patternImage: image!)


        } else{
            print("Something went wrong")
        }
        
        dismiss(animated:true, completion: nil)
        
    }
}


