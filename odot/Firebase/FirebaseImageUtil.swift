//
//  FirebaseImageUtil.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-11.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

class FirebaseImageUtil {
    
    let storage = Storage.storage()
    
    func loadImage(storageReference: String) -> UIImage? {
        let httpsReference = storage.reference(forURL: storageReference)
        var image = UIImage()
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print(error)
          } else {
            // Data for "images/island.jpg" is returned
            image = UIImage(data: data!) ?? UIImage()
          }
        }
        
        return image
        
    }
    
    func uploadImageFromDevice(imagePath: URL){
        
        let storageRef = storage.reference()
        
        if let user = Auth.auth().currentUser {
            
            let folderRef = storageRef.child("\(user.uid)")
            let uuid = UUID().uuidString
            let storageRef = folderRef.child("\(uuid).jpeg")
            //var newImageItem = ImagesItem(date: Date(), storageReference: storageRef.fullPath)
            //UPPLOAD ImagesItem to document array
            
            let localFile = imagePath

            let uploadTask = storageRef.putFile(from: localFile, metadata: nil) { metadata, error in
              guard let metadata = metadata else {
                return
              }
              print(metadata)
              // Metadata contains file metadata such as size, content-type.
              //let size = metadata.size
              // You can also access to download URL after upload.
              storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  return
                }
                var newImageItem = ImagesItem(date: Date(), storageReference: downloadURL.absoluteString)
              }
        
            }
            
            
        }
        
    }
    
}
