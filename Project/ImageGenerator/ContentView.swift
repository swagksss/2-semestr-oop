
//  ContentView.swift
//  ImageGenerator



import OpenAIKit
import SwiftUI

final class ViewModel : ObservableObject {
    private var openai : OpenAI?
    @Published var gallery: [UIImage] = []

    func setup (){
         openai = OpenAI(Configuration(
            organization: "Personal",
            apiKey: "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"))
    }

    func generateImage(prompt: String) async -> UIImage? {
        guard let openai = openai else {
            return nil
        }
        do {
            let params = ImageParameters(
                prompt: prompt,
                resolution: .medium,
                responseFormat: .base64Json

            )
            let result = try await  openai.createImage(
                parameters: params)
            let data = result.data[0].image
            let image = try openai.decodeBase64Image(data)
            addToGallery(image)
            return image
        }
        catch {
            print(String(describing: error))
            return nil
        }
    }

    func addToGallery(_ image: UIImage) {
            gallery.append(image)
        }
    }


struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var image : UIImage?
    @State var filteredImage : UIImage?
    @State var showSavedAlert = false // Add this line

    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                if let image = filteredImage ?? image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350, height: 350)

                }
                else {
                    Text("Type prompt to generate image!")
                }
                Spacer()

                TextField("Type prompt here ...", text: $text)
                    .padding()

                Button(action: {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        Task {
                            let result = await viewModel.generateImage(prompt: text)
                            if result == nil {
                                print("Failed to get image")
                            }
                            self.image = result
                        }
                    }
                }) {
                    Text("Generate")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)

                }
                .background(Color.gray)
                .cornerRadius(10)
                .padding(.horizontal)

                HStack {
                                    Button(action: {
                                        if let image = image {
                                            let filtered = applyFilter(image)
                                            self.filteredImage = filtered
                                        }
                                    }) {
                                        Text("Filter 1")
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)

                                    }
                                    .background(Color.gray)
                                    .cornerRadius(10)

                                    Button(action: {
                                        if let image = image {
                                            let filtered = applyFilter2(image)
                                            self.filteredImage = filtered
                                        }
                                    }) {
                                        Text("Filter 2")
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)

                                    }
                                    .background(Color.gray)
                                    .cornerRadius(10)


                                    Button(action: {
                                        if let image = image {
                                            let filtered = applyFilter3(image)
                                            self.filteredImage = filtered
                                        }
                                    }) {
                                        Text("Filter 3")
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)

                                    }
                                    .background(Color.gray)
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal)
                Button(action: {
                    if let image = filteredImage ?? image {
                        let imageView = ImageView(image: image)
                        let hostingController = UIHostingController(rootView: imageView)
                        UIApplication.shared.windows.first?.rootViewController?.present(hostingController, animated: true, completion: nil)
                    }
                }) {
                    Text("View Image")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)

                }
                .background(Color.gray)
                .cornerRadius(10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)

                HStack {
                                Button(action: {
                                    if let image = filteredImage ?? image {
                                        viewModel.addToGallery(image)
                                        showSavedAlert = true
                                    }
                                }) {
                                    Text("Save to Gallery")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)

                                }
                                .background(Color.gray)
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)

                                
                NavigationLink(destination: GalleryView(viewModel: viewModel)) {
                    Text("View Gallery")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)

                }
                .background(Color.gray)
                .cornerRadius(10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                }
                            }
                            .navigationTitle("Image Generator")
                            .onAppear {
                                viewModel.setup()
                            }
                            .padding()
                            .alert(isPresented: $showSavedAlert) {
                                Alert(title: Text("Image saved to gallery"))
                            }
                        }
                    }


    func applyFilter(_ image: UIImage) -> UIImage {
        // Implement your filter logic here
        // This example applies a sepia filter to the image
        let inputImage = CIImage(image: image)!
        let filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: kCIInputIntensityKey)
        let outputImage = filter.outputImage!
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        let filtered = UIImage(cgImage: cgImage)
        return filtered
    }
    func applyFilter2(_ image: UIImage) -> UIImage {
        // Implement your filter logic here
        // This example applies a sepia filter to the image
        let inputImage = CIImage(image: image)!
        let filter = CIFilter(name: "CIBloom")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: kCIInputIntensityKey)
        let outputImage = filter.outputImage!
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        let filtered = UIImage(cgImage: cgImage)
        return filtered
    }
    func applyFilter3(_ image: UIImage) -> UIImage {
        // Implement your filter logic here
        // This example applies a sepia filter to the image
        let inputImage = CIImage(image: image)!
        let filter = CIFilter(name: "CIVignetteEffect")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: kCIInputIntensityKey)
        let outputImage = filter.outputImage!
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        let filtered = UIImage(cgImage: cgImage)
        return filtered
    }
}
struct GalleryView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                    ForEach(viewModel.gallery, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                    }
                }
            }
            .navigationTitle("Gallery")
        }
    }
}

struct ImageView: View {
    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle("Generated Image", displayMode: .inline)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
