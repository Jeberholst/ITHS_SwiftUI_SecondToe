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
    
    func getUserCollection() -> CollectionReference? {
        return Firestore.firestore().collection("\(Auth.auth().currentUser!.uid)")
    }
    
    func updateUserDocument(newTodoItem: TodoItem){
        guard let docRef = getUserCollection() else { return }
        
        do {
            try docRef.document().setData(from: newTodoItem)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func archiveDocument(documentID: String){
        
        guard let docRef = getUserCollection()?.document(documentID) else { return }
        
        docRef.updateData(
            ["archive" : true]
        ){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
     
    }
    
    func deleteSingleUserDocument(documentID: String){
        
        guard let docRef = getUserCollection()?.document(documentID) else { return }
        
        docRef.delete(){ err in
            if let err = err {
                print("Error deleting document: \(err)")
            } else {
                print("Document successfully deleted")
            }
        }
        
    }
    
    func updateDocumentField(documentID: String, docData: [String : Any]){
        guard let docRef = getUserCollection()?.document(documentID) else { return }
  
        docRef.updateData(docData){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    func updateDocumentWholeArray(documentID: String, documentField: String, docData: [[String : Any]]){

        guard let docRef = getUserCollection()?.document(documentID) else { return }
        
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
        
        guard let docRef = getUserCollection()?.document(documentID) else { return }
        
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
    
}
