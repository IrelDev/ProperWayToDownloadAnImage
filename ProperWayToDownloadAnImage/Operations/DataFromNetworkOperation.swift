//
//  DataFromNetworkOperation.swift
//  ProperWayToDownloadAnImage
//
//  Created by Kirill Pustovalov on 19.09.2020.
//

import UIKit

class DataFromNetworkOperation: AsynchronousOperation {
    var urlToImage: URL
    let completion: (Data, URLResponse) -> Void
    
    var urlSessionDataTask: URLSessionDataTask?
    
    init(urlToImage: URL, completion: @escaping (Data, URLResponse) -> Void) {
        self.urlToImage = urlToImage
        self.completion = completion
    }
    
    override func main() {
        urlSessionDataTask = URLSession.shared.dataTask(with: urlToImage) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            defer { self.state = .finished }
            guard !self.isCancelled else { return }
            
            guard error == nil else { return }
            guard let data = data, let response = response else { return }
            
            self.completion(data, response)
        }
        urlSessionDataTask?.resume()
    }
    override func cancel() {
        super.cancel()
        urlSessionDataTask?.cancel()
    }
}
