//
//  Extension.swift
//  Unsplash Kraken
//
//  Created by William Santoso on 25/11/20.
//

import UIKit

extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from urlString: String, status: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
                status?(true)
            }
        }
    }
}

extension Int {
    func toStringFormatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: self as NSNumber) ?? "0"
    }
}
