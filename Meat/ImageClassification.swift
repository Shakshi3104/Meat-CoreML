//
//  ImageClassification.swift
//  Vision+ML SwiftUI
//
//  Created by MacBook Pro on 2021/07/11.
//

import Foundation
import UIKit
import ImageIO
import CoreML
import Vision

// MARK: - Image Classification
class ImageClassification: ObservableObject {
    @Published var classificationLabel: String = "Add a photo."
    @Published var isSearchable: Bool = false
    var classificationMeatPart: MeatPart = .gyu_harami
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let modelURL = Bundle.main.url(forResource: "RawMeatClassifier", withExtension: "mlmodelc")!
            let model = try VNCoreMLModel(for: RawMeatClassifier(contentsOf: modelURL).model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        classificationLabel = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.classificationLabel = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                
                print("\(topClassifications[0].identifier) \(topClassifications[0].confidence)")
                
                if topClassifications[0].confidence >= 0.9 {
                    self.classificationLabel = "It is \(topClassifications[0].identifier)!"
                }
                else if topClassifications[0].confidence >= 0.7 {
                    self.classificationLabel = "Likely \(topClassifications[0].identifier)."
                }
                else {
                    self.classificationLabel = "Maybe \(topClassifications[0].identifier)...\n  or \(topClassifications[1].identifier)"
                }
                
                self.isSearchable = true
                self.classificationMeatPart = MeatPart(rawValue: topClassifications[0].identifier)!
                print("\(self.classificationMeatPart.rakutenRecipeCategoryID)")
            }
        }
    }
}
