//
//  ApoloListViewController.swift
//  PruebaConceptoElTiempo
//
//  Created by mespinal on 5/03/21.
//

import UIKit
import Kingfisher
import MBProgressHUD

class ApoloListViewController: UIViewController
{
    @IBOutlet weak var apoloListTableView: UITableView!
    
    var apoloList: [ApoloModel] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apoloListTableView.alwaysBounceVertical = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        getApoloList()
    }

    
}

extension ApoloListViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.apoloList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let apoloItem: ApoloModel = self.apoloList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApoloViewCell", for: indexPath) as! ApoloViewCell
        
        let apoloData: ApoloDataModel = (apoloItem.apoloDataList?[0])!
        let apoloLinkList: [ApoloLinksModel] = apoloItem.apoloLinks ?? []
        
        
        cell.apoloTitle.text = apoloData.apoloDataTitle ?? ""
        
        if let apoloLink = apoloLinkList.filter({ $0.apoloLinkRel == "preview" }).first
        {
            if let url = URL(string: apoloLink.apoloLinkUrl!)
            {
                cell.apoloImage.kf.setImage(with: url, options: [
                    .transition(.fade(0.5))
                ])
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}

extension ApoloListViewController
{
    func getApoloList()
    {
        ConnectionManager.shareInstance.getApoloList() { (response, error) in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            if let apoloList = response?.collecctionApolo?.apoloItems
            {
                self.apoloList = apoloList
                self.apoloListTableView.reloadData()
            }
            
            if let error = error
            {
                print("Error al intentar traer la lista: \(error.localizedDescription)")
            }
        }
    }
}

/*extension ApoloListViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            if segue.identifier == "segueShowProductsFromCategory"
            {
                /*let apoloDetailViewController = segue.destination as! ProductsViewController
                productsViewController.productCategory = self.categorySelected
                productsViewController.isFromCategories = true*/
            }
        }
}*/

