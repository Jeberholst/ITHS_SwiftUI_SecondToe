//
//  CaptureImageView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-30.
//

import SwiftUI

struct ImagePickerPresenter: View {
    
    @EnvironmentObject var todos: Todos
    @State var todoItem: TodoItemOriginal
    @State var mainIndex: Int
    @State var isDisplayingImageChooser: Bool = false
    @State var image: Image? = Image(systemName: "photo")
    
    var body: some View {
        
        VStack {
        
            SheetSaveOnlyBarView(title: "New Image", actionSave: actionSave)
            
            Divider()
            
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 250, alignment: .center)
                .padding()
            
            ImagePicker(image: self.$image)
            
        }
        
    }
    
    private func actionSave(){
        print("Saving image...")
       // let newItem = ImagesItemOriginal(storageReference: "somestorageref")
//        todos.listOfItems[mainIndex].addImagesItem(item: newItem)
//        todoItem.addImagesItem(item: newItem)
    }
    
    
    
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var image: Image?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)

        }

    }
    

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
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

struct CaptureImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerPresenter(todoItem: TodoItemOriginal(),mainIndex: 0)
    }
}
