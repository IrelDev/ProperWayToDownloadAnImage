//
//  ViewController.swift
//  ProperWayToDownloadAnImage
//
//  Created by Kirill Pustovalov on 19.09.2020.
//

import UIKit

class ViewController: UIViewController {
    let imagesCount = 9
    var runningOperations: [IndexPath: Operation] = [:]
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    func buildURL(with id: Int) -> String {
        "https://lorempixel.com/1000/1000/abstract/\(id)/"
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imagesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ImageCell
        
        let stringUrlToImage = buildURL(with: indexPath.row)
        guard let urlToImage = URL(string: stringUrlToImage) else { return UITableViewCell() }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: urlToImage)) {
            cell.displayCell(with: UIImage(data: cachedResponse.data))
            return cell
        }
        
        let placeholderImage = UIImage(systemName: "icloud.and.arrow.down")
        cell.displayCell(with: placeholderImage)
        
        let downloadingOperation = DataFromNetworkOperation(urlToImage: urlToImage) { data, response in
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                cell.displayCell(with: image)
                self.imageToCache(data: data, response: response)
            }
        }
        downloadingOperation.start()
        runningOperations[indexPath] = downloadingOperation
        
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let operation = runningOperations[indexPath] else { return }
        operation.cancel()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        350
    }
    private func imageToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
extension ViewController {
    func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Images"
        
        tableView.register(ImageCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
