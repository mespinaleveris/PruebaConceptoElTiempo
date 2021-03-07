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
    var delegate: ApoloListViewProtocol?
    var indexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    @IBAction func setFavorite(_ sender: Any)
    {
        apoloItem.apoloIsFavorite = !apoloItem.apoloIsFavorite!
        delegate?.updateFavoriteInRow(name: apoloItem.apoloTitle!, isFavorite: apoloItem.apoloIsFavorite!, indexPath: self.indexPath)
        
        self.setFavoriteButton(buttonState: apoloItem.apoloIsFavorite!)
    }
}

extension DetailApoloViewController
{
    func setupView()
    {
        apoloTitleLabel.text = apoloItem.apoloTitle
        apoloDescLabel.text = apoloItem.apoloDesc
        
        self.setFavoriteButton(buttonState: apoloItem.apoloIsFavorite!)
        
        if let url = URL(string: apoloItem.apoloImageUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        {
            self.apoloImage.kf.setImage(with: url, options: [
                .transition(.fade(0.5))
            ])
        }
    }
    
    func setFavoriteButton(buttonState: Bool)
    {
        if buttonState
        {
            self.apoloFavoriteButton.setImage(UIImage(named: "icon_favorite_on"), for: .normal)
        }
        else
        {
            self.apoloFavoriteButton.setImage(UIImage(named: "icon_favorite_off"), for: .normal)
        }
    }
}
