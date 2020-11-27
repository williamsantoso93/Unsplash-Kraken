//
//  ViewController.swift
//  Unsplash Kraken
//
//  Created by William Santoso on 25/11/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //MARK: - inital collectionview
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        //MARK: - add searchbar
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type here to search image"
        navigationItem.searchController = search

        messageView.layer.cornerRadius = 10
        messageView.isHidden = true
        messageLabel.text = "Search Your Image"
    }
    
    var keyword = ""
    var searchText = ""
    let key = "IuP2PpGfrMl63nP59NgHXexBd0sv2JC89_wNXZYa6gc"
    var totalPage = 0
    var currentPage = 1
    var imageDatas = [Result]()
    var isNoResult = false {
        didSet {
            if isNoResult {
                messageView.isHidden = true
                messageLabel.isHidden = false
                messageLabel.text = "No result found"
            } else {
                messageLabel.isHidden = true
            }
        }
    }
    var isDone = true {
        didSet {
            if isDone {
                messageView.isHidden = true
                loadingIndicatorView.stopAnimating()
            } else {
                messageView.isHidden = false
                loadingIndicatorView.startAnimating()
            }
        }
    }
    
    func getData() {
        let query = keyword.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = "https://api.unsplash.com/search/photos?client_id=\(key)&query=\(query)&page=\(currentPage)"
        
        isDone = false
        isNoResult = false
        
        guard let url = URL(string: urlString) else {
            print("bad url")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print(urlString)
                print("no data")
                return
            }
            
            guard let decoded = try? JSONDecoder().decode(ImageData.self, from: data) else {
                print(urlString)
                print(String(data: data, encoding: .utf8) ?? "no data")
                print("decoding error")
                return
            }
            
            DispatchQueue.main.async {
                let newImageDatas = decoded.results
                let oldImageDatas = self.imageDatas
                self.imageDatas = oldImageDatas + newImageDatas
                self.totalPage = decoded.totalPages
                self.isDone = true
                self.currentPage += 1
                self.imageCollectionView.reloadData()
                if self.imageDatas.isEmpty {
                    self.isNoResult = true
                }
            }
            
        }.resume()
    }
    
    var currentResult: Result?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToImageView" {
            let controller = segue.destination as! ImageViewController
            
            guard let result = currentResult else { return }
            controller.result = result
        }
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let urlString = imageDatas[indexPath.row].urls.thumb
        cell.imageView.downloadImage(from: urlString)
        cell.likesLabel.text = imageDatas[indexPath.row].likes.toStringFormatted()
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentResult = imageDatas[indexPath.row]
        performSegue(withIdentifier: "GoToImageView", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (imageDatas.count - 4) {
            currentPage += 1
            
            if currentPage <= totalPage {
                getData()
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize : CGRect = UIScreen.main.bounds
        var widthCell = 0
        
        widthCell = Int((screenSize.width - 50) / 2)
        
        return CGSize(width: widthCell, height: widthCell)
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        keyword = text
        imageDatas.removeAll()
        currentPage = 1
        getData()
    }
}
