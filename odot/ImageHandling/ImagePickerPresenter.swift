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
    @State var imageURL: URL? = URL(string: "")
    
    var body: some View {
        
        VStack {
        
            SheetSaveOnlyBarView(title: "New Image", actionSave: actionSave)
            
            Divider()
            
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 250, alignment: .center)
                .padding()
            
            ImagePicker(image: self.$image, imageURL: self.$imageURL)
            
        }
        
    }
    
    private func actionSave(){
        
        print("Saving image...")
        print(imageURL?.absoluteURL as Any)
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if let user = Auth.auth().currentUser {
            
            let folderRef = storageRef.child("\(user.uid)")
            let uuid = UUID().uuidString
            let storageRef = folderRef.child("\(uuid).jpeg")
            //var newImageItem = ImagesItem(date: Date(), storageReference: storageRef.fullPath)
            //UPPLOAD ImagesItem to document array
            if let imageUrl = imageURL {
                
                //let localFile = imageURL

                let uploadTask = storageRef.putFile(from: imageUrl, metadata: nil) { metadata, error in
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
    @Binding var imageURL: URL?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        @Binding var imageURL: URL?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, imageURL: Binding<URL?>) {
            _presentationMode = presentationMode
            _image = image
            _imageURL = imageURL
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
         
            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                imageURL = URL.init(fileURLWithPath: localPath)
               
            }
            
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
//
//struct CaptureImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePickerPresenter(todoItem: TodoItem(),mainIndex: 0)
//    }
//}
