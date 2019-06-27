//
//  ViewController.swift
//  instagrid
//
//  Created by SayajinPapuru on 04/05/2019.
//  Copyright © 2019 sayajin papuru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - @IBoutlets
    @IBOutlet var plusUIButtons: [UIButton]!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet var gridViews: [UIView]!
    @IBOutlet var imagesViews: [UIImageView]!
    @IBOutlet var layoutButtns: [UIButton]!
    
    //MARK: - Vars
    var tag: Int?
    var swipeGesture: UISwipeGestureRecognizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        guard let swipeGesture = swipeGesture else { return }
        mainContainer.addGestureRecognizer(swipeGesture)
        setUpDirection()
        NotificationCenter.default.addObserver(self, selector: #selector(setUpDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    @objc func swipeHandler(_ gesture: UISwipeGestureRecognizer) {
        if swipeGesture?.direction == .up {
            UIView.animate(withDuration: 0.7, animations: {self.mainContainer.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)})
                shareIt()
            
        } else {
            UIView.animate(withDuration: 0.7, animations: {self.mainContainer.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)})
            shareIt()
        }
    }
    
    @objc func setUpDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGesture?.direction = .left
        } else {
            swipeGesture?.direction = .up
        }
    }
    
    //MARK: - @IBActions
    @IBAction func plusOnClick(_ sender: UIButton) {
        tag = sender.tag
        pickerController()
    }
    
    @IBAction func layoutsOnClick(_ sender: UIButton) {
        layoutButtns.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        switch sender.tag {
        case 0:
            gridViews[1].isHidden = true
            gridViews[3].isHidden = false
        case 1:
            
            gridViews[1].isHidden = false
            gridViews[3].isHidden = true
        case 2:
            
            gridViews[1].isHidden = false
            gridViews[3].isHidden = false
        default:
            break
        }
        
    }
    
    func resetView() {
        UIView.animate(withDuration: 0.7) {
            self.mainContainer.transform = .identity
        }
    }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Image Picker Controller
    
    //Alert Choice to Library Or Camera
    func pickerController() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionMenu.addAction(UIAlertAction(title: "Library", style: .default, handler: { (actionMenu) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionMenu.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (actionMenu) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        
        actionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: (nil)))
        self.present(actionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let tag = tag else { return }
        
        imagesViews[tag].image = image
        plusUIButtons[tag].isHidden = true
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(imageSelected(gesture:)))
        imagesViews[tag].addGestureRecognizer(tapGestureImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageSelected(gesture: UIGestureRecognizer) {
        gesture.view?.tag = tag!
        pickerController()
    }
    
    func shareIt() {
        guard let image = mainContainer.convertToImage() else { return }
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        share.popoverPresentationController?.sourceView = self.view
        self.present(share, animated: true, completion: nil)
        
        share.completionWithItemsHandler = { (_, completed, _, _) in
            if completed {
                self.resetView()
                self.resetImages()
            } else {
                self.resetView()
                print("annuler")
            }
        }
    }
    
    //Add plus button when all removed
    

    func resetImages() {
        for image in imagesViews {
            image.image = UIImage()
            guard let tag = tag else { return }
            plusUIButtons[tag].isHidden = false
        }
    }
}



