//
//  ImageViewController.swift
//  Unsplash Kraken
//
//  Created by William Santoso on 25/11/20.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var portfolioUrlLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var portfolioStackView: UIStackView!
    @IBOutlet weak var instagramStackView: UIStackView!
    
    
    var result: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let result = result else { return }
        
        image.downloadImage(from: result.urls.regular) { (isDone) in
            if isDone {
                self.loadingIndicator.stopAnimating()
            }
        }
        
        likesLabel.text = result.likes.toStringFormatted()
        
        profileImage.downloadImage(from: result.user.profileImage.small)
        profileImage.layer.cornerRadius = profileImage.layer.frame.width/2
        profileImage.layer.masksToBounds =  true
        
        profileNameLabel.text = result.user.name
        if let portfolioURL = result.user.portfolioURL {
            portfolioUrlLabel.text = portfolioURL
        } else {
            portfolioStackView.isHidden = true
        }
        if let instagramUsername = result.user.instagramUsername {
            instagramLabel.text = "@" + instagramUsername
        } else {
            instagramStackView.isHidden = true
        }
        if let resultDescription = result.resultDescription {
            descriptionLabel.text = resultDescription
        } else {
            descriptionLabel.isHidden = true
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
