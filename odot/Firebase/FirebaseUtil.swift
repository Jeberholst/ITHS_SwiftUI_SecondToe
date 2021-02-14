//
//  FirebaseUtil.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-04.
//

import Foundation
import FirebaseFirestore
import FirebaseUI

struct FirebaseUtil {
    static let firebaseUtil = FirebaseUtil()
    
    var instance = Firestore.firestore()
    let documentFieldImages = "images"
    
    private init(){}
    
    func getUserCollection() -> CollectionReference {
        return Firestore.firestore().collection("\(Auth.auth().currentUser!.uid)")
    }
    
    func updateUserDocument(newTodoItem: TodoItem){
        do {
            try getUserCollection().document().setData(from: newTodoItem)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func updateDocumentField(documentID: String, docData: [String : Any]){
        
        let docRef = getUserCollection().document(documentID)
  
        docRef.updateData(docData){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    func updateDocumentWholeArray(documentID: String, documentField: String, docData: [[String : Any]]){

        let docRef = getUserCollection().document(documentID)
        
        docRef.updateData([
            documentField: docData
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateDocumentFieldArrayUnion(documentID: String, documentField: String, docData: [String : Any]){
        
        let docRef = getUserCollection().document(documentID)
        
        docRef.updateData([
            documentField: FieldValue.arrayUnion([docData])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func uploadImageToStorage(documentID: String, imageData: Data?){
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if let user = Auth.auth().currentUser {
            
            let folderRef = storageRef.child("\(user.uid)")
            let uuid = UUID().uuidString
            let storageRef = folderRef.child("\(uuid).jpeg")
           
            if let imageData = imageData {
                
                let metaData =  StorageMetadata()
                metaData.contentType = "image/jpg"

                let uploadTask = storageRef.putData(imageData, metadata: metaData) { metadata, error in
                  guard let metadata = metadata else {
                    return
                  }
                   
                  storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      return
                    }
              
                    let newImageItem = ImagesItem(date: Date(), storageReference: downloadURL.absoluteString)
                    let docData : [String: Any] = newImageItem.getAsDictionary()
                    updateDocumentFieldArrayUnion(documentID: documentID, documentField: documentFieldImages, docData: docData)
                    
                  }
            
                }
            }
        }
    }
    
    func deleteImageFromStorage(documentID: String, imageName: String, docData: [[String: Any]]){
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if let user = Auth.auth().currentUser {
            
            let folderRef = storageRef.child("\(user.uid)")
            let imageStorageRef = folderRef.child("\(imageName)")
           
            imageStorageRef.delete { error in
              if let error = error {
                // Uh-oh, an error occurred!
              } else {
                updateDocumentWholeArray(documentID: documentID, documentField: documentFieldImages, docData: docData)
              }
            }
             
        }
    }
    
    func removeUserAccount(){
        
        let authUI = FUIAuth.defaultAuthUI()
        let userAcc = Auth.auth().currentUser
        print("Trying to sign out user...")
        try! authUI?.signOut()
        userAcc?.delete { error in
          if let error = error {
            print("Delete account error: \(error)")
          } else {
            print("Account deleted")
          }
        }
   
    }
    
    
    private func deleteUserStorageFolder() {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if let user = Auth.auth().currentUser {
            
            let folderRef = storageRef.child("\(user.uid)")
            folderRef.delete()
          
        }
    }
    
}
