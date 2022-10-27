//
//  CreateCustomEventVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 29/09/22.
//

import UIKit
import TOCropViewController

protocol EditCustomEventDelegate {
    func eventEdited(event:EventModal)
}

class CreateCustomEventVC: UIViewController {
    @IBOutlet var eventImageView: CustomImageView!
    @IBOutlet var changePhotoView: UIView!
    @IBOutlet var eventTitleTxt: UITextField!
    @IBOutlet var dateTxt: UITextField!
    @IBOutlet var descTxtView: UITextView!
    
    var imagePicker : ImagePicker!
    var selectedImage : UIImage?
    var isRemoveImage = false
    var selectedDate:Date?
    var viewModal = CalendarVM()
    var isEdit = false
    var textViewPlaceholderColor = UIColor.lightGray
    var event = EventModal()
    var delegate:EditCustomEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        eventImageView.roundCorners(cornerRadius: 25.0, cornerMask: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
        eventImageView.layer.borderWidth = 1.0
        eventImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        changePhotoView.layer.cornerRadius = 35/2
        changePhotoView.backgroundColor = UIColor.init(hexString: "#F6F1F1").withAlphaComponent(0.6)
        imagePicker = ImagePicker(presentationController: self,editing: false, delegate: self)
        eventTitleTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: eventTitleTxt, leftWidth: 10, rightWidth: 10)
        setPlaceholderColor(textfield: eventTitleTxt)
        dateTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: dateTxt)
        setTextfieldPadding(textfield: dateTxt, leftWidth: 10, rightWidth: 50)
        descTxtView.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        descTxtView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        descTxtView.layer.borderWidth = 1.0
        descTxtView.layer.borderColor = UIColor.init(hexString: "#E3E1E1").cgColor
        descTxtView.textColor = textViewPlaceholderColor
        descTxtView.text = "Write something.."
        if isEdit{
           setEditUI()
        }
    }
    
    func setPlaceholderColor(textfield:UITextField){
        textfield.attributedPlaceholder = NSAttributedString(
            string: textfield.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    }
    func setTextfieldPadding(textfield:UITextField,leftWidth:Int,rightWidth:Int){
        let btnViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: leftWidth, height: 50))
        let btnViewRight = UIView(frame: CGRect(x: 0, y: 0, width: rightWidth, height: 50))
        textfield.rightViewMode = .always
        textfield.rightView = btnViewRight
        textfield.leftView = btnViewLeft
        textfield.leftViewMode = .always
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dateBtnClicked(_ sender: Any) {
        presentDatePicker()
    }
    
    func presentDatePicker(){
        let VC = self.getDatePickerVC()
        VC.selectedDate = self.selectedDate
        VC.delegate = self
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
    
    @IBAction func changePhotoBtnClicked(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if validateFieldValues(){
            if isEdit{
                self.editCustomActivityRequest()
            }else{
                self.customActivityRequest()
            }
        }
    }
    
    func validateFieldValues()->Bool{
        if selectedImage == nil && event.eventImage.isEmpty{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.eventImageEmpty, type: .danger)
            return false
        }
        guard let eventTitle = eventTitleTxt.text,!eventTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.eventTitleEmpty, type: .danger)
            return false
        }
        guard let date = dateTxt.text,!date.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.dateEmpty, type: .danger)
            return false
        }
        guard let desc = descTxtView.text,!desc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.eventDescEmpty, type: .danger)
            return false
        }
        if descTxtView.textColor == textViewPlaceholderColor{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.eventDescEmpty, type: .danger)
            return false
        }
        return true
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

extension CreateCustomEventVC{
    func setEditUI(){
        eventImageView.ImageViewLoading(mediaUrl: event.eventImage, placeHolderImage: UIImage(named: "noImageEvent"))
        eventTitleTxt.text = event.eventTitle
        dateTxt.text = event.eventdateAsDate.toString(dateFormat: "MM/dd/YYYY")
        selectedDate = event.eventdateAsDate
        descTxtView.text = event.eventdesc
        descTxtView.textColor = .black
    }
}

extension CreateCustomEventVC : DatePickerDelegate{
    func dateSelected(date: Date?) {
        self.selectedDate = date
        self.dateTxt.text = date?.toString(dateFormat: "MM/dd/YYYY")
    }

}
extension CreateCustomEventVC : ImagePickerDelegate,TOCropViewControllerDelegate{
    func cancelClicked() {
        
    }
    func didSelect(image: UIImage?,fileUrl:URL?, isRemove: Bool) {
        if isRemove{
            self.isRemoveImage = isRemove
            selectedImage = nil
            eventImageView.image = nil
            return
        }
        if image != nil{
            presentCropViewController(image: image!)
        }
    }
    
    func presentCropViewController(image:UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.customAspectRatio = CGSize(width: 16, height: 9)
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        selectedImage = image
        eventImageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension CreateCustomEventVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if textField == eventTitleTxt{
           // make sure the result is under 16 characters
           return updatedText.count <= 15
        }
        return true
    }
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300    // 300 Limit Value
    }*/
}

extension CreateCustomEventVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == textViewPlaceholderColor {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write something.."
            textView.textColor = textViewPlaceholderColor
        }
    }

}

extension CreateCustomEventVC{
    
    func customActivityRequest(){
        let param = ["title":eventTitleTxt.text!.trimmingCharacters(in: .whitespaces),
                     "date":selectedDate!.toString(dateFormat: "yyyy-MM-dd"),
                     "description":descTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines)] as [String:Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.createCustomActivity(param: param, removeImage: isRemoveImage, image: selectedImage, fileName: "image_file", onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.customEventCreated, type: .success)
            self.backBtnClicked(self)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func editCustomActivityRequest(){
        let param = ["title":eventTitleTxt.text!.trimmingCharacters(in: .whitespaces),
                     "date":selectedDate!.toString(dateFormat: "yyyy-MM-dd"),
                     "description":descTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines)] as [String:Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.updateCustomActivity(id:self.event.eventId,param: param, removeImage: isRemoveImage, image: selectedImage, fileName: "image_file", onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.customEventEdited, type: .success)
            self.delegate?.eventEdited(event: self.viewModal.event)
            self.backBtnClicked(self)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}
