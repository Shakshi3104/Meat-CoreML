//
//  ImageDownload.swift
//  Meat
//
//  Created by MacBook Pro M1 on 2021/08/10.
//

import Foundation
import SwiftUI


/// https://qiita.com/From_F/items/e3eb8bd279f75b864865
class ImageDownloader : ObservableObject {
    @Published var downloadData: Data? = nil

    func downloadImage(url: String) {

        guard let imageURL = URL(string: url) else { return }

        let task: URLSessionTask = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            DispatchQueue.main.async {
                self.downloadData = data
            }
        }
        task.resume()
    }
}

struct URLImage: View {

    let url: String
    @ObservedObject private var imageDownloader = ImageDownloader()

    init(url: String) {
        self.url = url
        self.imageDownloader.downloadImage(url: self.url)
    }

    var body: some View {
        if let imageData = self.imageDownloader.downloadData {
            let img = UIImage(data: imageData)
            return VStack {
                Image(uiImage: img!).resizable()
            }
        } else {
            return VStack {
                Image(systemName: "icloud.and.arrow.down")
            }
        }
    }
}
