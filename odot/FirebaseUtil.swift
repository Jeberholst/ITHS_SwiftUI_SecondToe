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
    
    func getUserCollection() -> CollectionReference {
        let currUserUid = Auth.auth().currentUser!.uid
        print(currUserUid)
        return Firestore.firestore().collection("\(currUserUid)")
    }
    
    
    private init(){}
    
    
}
