//
//  CaptureImageView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-30.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth

struct ImagePickerPresenter: View {
        
    private let fbUtil: FirebaseUtil = FirebaseUtil.firebaseUtil
    var docID: String
    @State var isDisplayingImageChooser: Bool = false
    @State var image: Image? = Image(systemName: "photo")
    @State var imageData: Data? = Data()
    
    var body: some View {
        
        VStack {
        
            SheetSaveOnlyBarView(title: "New Image", actionSave: actionSave)
            
            Divider()
            
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 250, alignment: .center)
                .padding()
            
            ImagePicker(image: self.$image, imageURL: self.$imageData)
            
        }
        
    }
    
    private func actionSave(){
        
        print("Saving image...")
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if let user = Auth.auth().currentUser {
            
            let folderRef = storageRef.child("\(user.uid)")
            let uuid = UUID().uuidString
            let storageRef = folderRef.child("\(uuid).jpeg")
           
            if let imageUrl = imageData {
                
                let metaData =  StorageMetadata()
                metaData.contentType = "image/jpg"

                let uploadTask = storageRef.putData(imageUrl, metadata: metaData) { metadata, error in
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
                    let documentField = "images"
                    let newImageItem = ImagesItem(date: Date(), storageReference: downloadURL.absoluteString)
                    let docData : [String: Any] = newImageItem.getAsDictionary()
                    //docData = newImageItem.getAsDictionary()
                    fbUtil.updateDocumentFieldArrayUnion(documentID: docID, documentField: documentField, docData: docData)
                    
                    
                  }
            
                }
                
                
                
            }
            
            
        }
        
    }
    
    
    
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var image: Image?
    @Binding var imageURL: Data?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        @Binding var imageData: Data?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, imageURL: Binding<Data?>) {
            _presentationMode = presentationMode
            _image = image
            _imageData = imageURL
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                
            let targetSize = CGSize(width: 200, height: 200)
            let scaledImage = uiImage.scalePreservingAspectRatio(
                targetSize: targetSize
            )
            
            image = Image(uiImage: scaledImage)
            var data = Data()
            data = scaledImage.jpegData(compressionQuality: 0.8)!
            imageData = data
          
        }

    }
    

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, imageURL: $imageURL)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
     
        picker.delegate = context.coordinator
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
            
    }
    
}


extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
//
//struct CaptureImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePickerPresenter(todoItem: TodoItem(),mainIndex: 0)
//    }
//}
