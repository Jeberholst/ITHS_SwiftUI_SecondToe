//
//  CaptureImageView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-30.
//

import SwiftUI

struct ImagePickerPresenter: View {
    
    private let FIU: FirebaseImageUtil = FirebaseImageUtil()
    @State var todoItem: TodoItem
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
        
        FIU.uploadImageFromDevice(imagePath: (imageURL)!)
        
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
