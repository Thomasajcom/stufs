//
//  AddItemVC+Extension.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 03/11/2020.
//

import Foundation
import UIKit

// MARK: - St_AddItemTextInputCellDelegate
extension AddItemVC: St_AddItemTextInputCellDelegate {
    func textFieldWasSet(to name: String, for textFieldIdentifier: TextFieldIdentifier) {
        switch textFieldIdentifier {
        case .itemName:
            self.newItem.name = name
        case .acquiredFrom:
            self.newItem.acquiredFrom = name
        }
        self.canItemBeSaved()
    }
    
    
}

// MARK: - St_AddItemGroupSelectorCellDelegate
extension AddItemVC: St_AddItemGroupSelectorCellDelegate {
    func goToGroupSelection(group: St_Group?) {
        let groupSelector = GroupSelectorVC(coreDataStore: self.coreDataStore, group: group, context: self.newItem.managedObjectContext!)
        groupSelector.groupSelectorVCDelegate = self
        groupSelector.isModalInPresentation = true
        present(groupSelector, animated: true)
    }
}


// MARK: - GroupSelectorVCDelegate
extension AddItemVC: GroupSelectorVCDelegate {
    func updateSelectedGroup(with group: St_Group) {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? St_AddItemGroupSelectorCell
        cell?.set(group: group)
        self.newItem.group = group
        self.canItemBeSaved()
    }
}

// MARK: - WarrantyLengthDelegate
extension AddItemVC: St_AddItemWarrantyCellDelegate {
    func goToWarrantyPicker() {
        let warrantyPicker = WarrantyPickerVC()
        warrantyPicker.warrantyPickerDelegate = self
        present(warrantyPicker, animated: true)
    }
}

// MARK: - WarrantyPickerVCDelegate
extension AddItemVC: WarrantyPickerVCDelegate {
    func setWarrantyLength(_ warrantyLength: WarrantyLength) {
        self.newItem.warrantyLength = Int64(warrantyLength.warrantyLengthInDays)
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? St_AddItemWarrantyCell
        cell?.setWarrantyLength(days: warrantyLength.warrantyLengthInDays)
    }
}

// MARK: - AddItemImageDelegate
extension AddItemVC: St_AddItemImageCellDelegate {
    func showImagePicker(for imageType: St_AddItemImage) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true) {
                self.selectedImage = imageType
                print("completed presenting!")
            }
            
        } else {
            #warning("Prompt user with an alert here")
            print("camera not available")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddItemVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let editedImage: UIImage? = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let originalImage: UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageToSave = editedImage ?? originalImage
        
        if self.selectedImage != nil {
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? St_AddItemImageCell
            switch self.selectedImage {
            case .item:
                cell?.itemImage.image = imageToSave
                cell?.itemImage.isHidden = false
                self.newItem.itemPhoto = imageToSave?.pngData()
            case .receipt:
                cell?.receiptImage.image = imageToSave
                cell?.receiptImage.isHidden = false
                self.newItem.receiptPhoto = imageToSave?.pngData()
            case .none:
                print("something went wrong when switching selectedImage on AddItemVC")
            }
        }
        //saves the image to device gallery if the source type was camera
        #warning("Add 'save photos to library?' in Settings and check that value here")
        if picker.sourceType == UIImagePickerController.SourceType.camera {
            UIImageWriteToSavedPhotosAlbum(editedImage!, nil, nil, nil)
        }
        picker.dismiss(animated: true) {
            print("dismissed imagepicker after user picked")
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            print("dismissed imagepicker after user cancelled")
        }
    }
    
}
