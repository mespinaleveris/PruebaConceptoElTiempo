//
//  DetailApoloViewController.swift
//  PruebaConceptoElTiempo
//
//  Created by mespinal on 6/03/21.
//

import UIKit
import Kingfisher

class DetailApoloViewController: UIViewController
{
    @IBOutlet weak var apoloTitleLabel: UILabel!
    @IBOutlet weak var apoloDescLabel: UILabel!
    @IBOutlet weak var apoloImage: UIImageView!
    @IBOutlet weak var apoloFavoriteButton: UIButton!
    
    var apoloItem: ApoloModel = ApoloModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    
}

extension DetailApoloViewController
{
    func setupView()
    {
        apoloTitleLabel.text = apoloItem.apoloTitle
        apoloDescLabel.text = apoloItem.apoloDesc
        
        if let url = URL(string: apoloItem.apoloImageUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        {
            self.apoloImage.kf.setImage(with: url, options: [
                .transition(.fade(0.5))
            ])
        }
    }
}
