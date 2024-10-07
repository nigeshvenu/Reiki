//
//  ImagePicker.swift
//  iAautoauctionDealer
//
//  Created by NewAgeSMB on 21/05/21.
//

import UIKit
import AVFoundation
import Photos

public enum ImagePickerType {
    case Photo
    case none
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?,fileUrl:URL?,isRemove:Bool)
    func cancelClicked()
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    var isTakePhoto = true
    var isPhotoLibraray = true
    var isDocumentPicker = false
    var isRemove = false
   
    public init(presentationController: UIViewController,editing:Bool = true, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = editing
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    public func present(from sourceView: UIView,showActionSheet:Bool = true,actionType:ImagePickerType = .none) {
        if showActionSheet{
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if isTakePhoto{
                if let action = self.action(for: .camera, title: "Take Photo") {
                    alertController.addAction(action)
                }
            }
            if isPhotoLibraray{
                if let action = self.action(for: .photoLibrary, title: "Photo Library") {
                    alertController.addAction(action)
                }
            }
            if isDocumentPicker{
                let action = UIAlertAction(title: "Browse", style: .default) { (action) in
                    self.presentDocument()
                }
                alertController.addAction(action)
            }
            
            if isRemove{
                let action = UIAlertAction(title: "Remove", style: .destructive) { (action) in
                    self.delegate?.didSelect(image: nil, fileUrl: nil, isRemove: true)
                }
                alertController.addAction(action)
            }
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceView.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
            }
            self.presentationController?.present(alertController, animated: true)
        }else{
            if actionType == .Photo{
                self.checkPhotoGalleryPermission {
                    self.presentSource(type: .photoLibrary)
                }
            }
        }
        
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        /*guard UIImagePickerController.isSourceTypeAvailable(type) else {
          let alert  = UIAlertController(title: "Warning", message: "Unable to access source", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.presentationController?.present(alert, animated: true, completion: nil)
          return nil
        }*/
        return UIAlertAction(title: title, style: .default) { (action) in
            if type == .camera{
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    self.checkCameraPermission {
                        self.presentSource(type: type)
                    }
                }
            }else{
               
                self.checkPhotoGalleryPermission {
                    self.presentSource(type: type)
                }
            }
        }
    }
    
    private func presentSource(type:UIImagePickerController.SourceType){
        
        self.pickerController.sourceType = type
        self.presentationController?.present(self.pickerController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image, fileUrl: nil, isRemove: false)
    }
}

extension ImagePicker{
    
    func checkCameraPermission(completion: @escaping () -> Void){
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .denied, .restricted:
            redirectToSettings(title: "Allow access to your camera", message: "Go to your settings and enable \"Camera\".")
        case .authorized:
            completion()
        case .notDetermined:
            NSLog("cameraAuthorizationStatus=notDetermined")
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        // do something
                        completion()
                    } else {
                        // do something else
                    }
                }
            }
        @unknown default:
            fatalError()
        }
        
    }
    
    func checkPhotoGalleryPermission(completion: @escaping () -> Void){
        var status : PHAuthorizationStatus!
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            // Fallback on earlier versions
            status = PHPhotoLibrary.authorizationStatus()
        }
        switch status {
        case .authorized:
        //handle authorized status
            completion()
        case .denied, .restricted :
            redirectToSettings(title: "Allow access to your photos", message: "Go to your settings and tap \"Photos\".")
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        completion()
                    }
                // as above
                case .denied, .restricted: break
                // as above
                case .notDetermined: break
                // won't happen but still
                case .limited:
                    DispatchQueue.main.async {
                        completion()
                    }
                @unknown default:
                    break
                }
            }
        case .limited:
            completion()
        case .none:
            break
        @unknown default:
            break
        }
    }
    
    func redirectToSettings(title:String,message:String){
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
             })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.presentationController?.present(alertController, animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if pickerController.allowsEditing{
            guard let image = info[.editedImage] as? UIImage else {
                return self.pickerController(picker, didSelect: nil)
            }
            self.pickerController(picker, didSelect: image)
        }else{
            guard let image = info[.originalImage] as? UIImage else {
                return self.pickerController(picker, didSelect: nil)
            }
            self.pickerController(picker, didSelect: image)
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.delegate?.cancelClicked()
    }
  
}

extension ImagePicker : UIDocumentPickerDelegate{
    
    func presentDocument(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf","public.jpeg","public.png"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        self.presentationController?.present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Handle your document
        for url in urls{
            self.delegate?.didSelect(image: nil, fileUrl: url, isRemove: false)
        }
    }
    
}
