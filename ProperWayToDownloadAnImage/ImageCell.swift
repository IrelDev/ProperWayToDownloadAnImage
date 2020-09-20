//
//  ImageCell.swift
//  ProperWayToDownloadAnImage
//
//  Created by Kirill Pustovalov on 19.09.2020.
//

import UIKit

class ImageCell: UITableViewCell {
    let cellImageView: UIImageView = {
        let cellImageView = UIImageView()
        
        cellImageView.clipsToBounds = true
        cellImageView.layer.cornerRadius = 25
        cellImageView.tintColor = .label
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return cellImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellImageView)
        NSLayoutConstraint.activate([
            cellImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cellImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: 300),
            cellImageView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func displayCell(with image: UIImage?) {
        cellImageView.image = image
    }
}
