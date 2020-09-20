//
//  ImageFromNetworkOperation.swift
//  ProperWayToDownloadAnImage
//
//  Created by Kirill Pustovalov on 19.09.2020.
//

import UIKit

class ImageFromNetworkOperation: AsynchronousOperation {
    var urlToImage: String
    let completion: (UIImage) -> Void
    
    var urlSessionDataTask: URLSessionDataTask?
    
    init(urlToImage: String, completion: @escaping (UIImage) -> Void) {
        self.urlToImage = urlToImage
        self.completion = completion
    }
    
    override func main() {
        guard let url = URL(string: urlToImage) else { return }
        urlSessionDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            defer { self.state = .finished }
            guard !self.isCancelled else { return }
            
            guard error == nil, let data = data, let image = UIImage(data: data) else { return }
            
            self.completion(image)
        }
        urlSessionDataTask?.resume()
    }
    override func cancel() {
        super.cancel()
        urlSessionDataTask?.cancel()
    }
}
