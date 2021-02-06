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
    
    private init(){}
    
    func getUserCollection() -> CollectionReference {
        let currUserUid = Auth.auth().currentUser!.uid
        print(currUserUid)
        return Firestore.firestore().collection("\(currUserUid)")
    }
    
    func updateDocument(documentID: String, docData: [String : Any]){
        
        print("Updating \(documentID)...")
        
        let docRef = getUserCollection().document(documentID)
  
        docRef.updateData(docData){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    func updateDocumentFieldArrayUnion(documentID: String, documentField: String, docData: [String : Any]){
        
        print("Updating \(documentID) Array...")

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
    
}
