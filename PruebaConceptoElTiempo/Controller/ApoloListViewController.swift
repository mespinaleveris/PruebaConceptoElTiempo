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
    @IBOutlet weak var apoloListSearchBar: UISearchBar!
    
    var apoloList: [ApoloModel] = [];
    var searchedApoloList: [ApoloModel] = [];
    var searching: Bool = false
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apoloListTableView.alwaysBounceVertical = true
        self.apoloListSearchBar.showsCancelButton = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        getApoloList()
    }

    
}

extension ApoloListViewController: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchedApoloList = apoloList.filter { $0.apoloTitle!.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        
        apoloListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        apoloListTableView.reloadData()
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
        if searching
        {
            return searchedApoloList.count
        }
        else
        {
            return self.apoloList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var apoloItem: ApoloModel = ApoloModel()
        
        if searching
        {
            apoloItem = self.searchedApoloList[indexPath.row]
        }
        else
        {
            apoloItem = self.apoloList[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApoloViewCell", for: indexPath) as! ApoloViewCell
        
        let apoloData: ApoloDataModel = (apoloItem.apoloDataList?[0])!
        let apoloLinkList: [ApoloLinksModel] = apoloItem.apoloLinks ?? []
        
        
        cell.apoloTitle.text = apoloData.apoloDataTitle ?? ""
        
        if let apoloLink = apoloLinkList.filter({ $0.apoloLinkRel == "preview" }).first
        {
            if let url = URL(string: apoloLink.apoloLinkUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
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
            
            if var apoloList = response?.collecctionApolo?.apoloItems
            {
                for i in 0..<apoloList.count
                {
                    let apoloTitle = apoloList[i].apoloDataList![0].apoloDataTitle ?? ""
                    let apoloDesc = apoloList[i].apoloDataList![0].apoloDataDesc ?? ""
                    var apoloImageUrl = ""
                    
                    if let apoloLink = apoloList[i].apoloLinks?.filter({ $0.apoloLinkRel == "preview" }).first
                    {
                        apoloImageUrl = apoloLink.apoloLinkUrl ?? ""
                    }
                    
                    apoloList[i].apoloTitle = apoloTitle
                    apoloList[i].apoloDesc = apoloDesc
                    apoloList[i].apoloImageUrl = apoloImageUrl
                }
                
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

