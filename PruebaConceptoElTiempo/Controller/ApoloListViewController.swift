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
    
    var apoloItemSelected = ApoloModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apoloListTableView.alwaysBounceVertical = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.getSavedList()
    }

    
}

extension ApoloListViewController: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchedApoloList.removeAll()
        
        for apoloItem in self.apoloList
        {
            if apoloItem.apoloKeywords!.filter({ $0.lowercased().prefix(searchText.count) == searchText.lowercased() }).count > 0
            {
                self.searchedApoloList.append(apoloItem)
            }
        }
        
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
        
        cell.selectionStyle = .none
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.searching
        {
            self.apoloItemSelected = self.searchedApoloList[indexPath.row]
        }
        else
        {
            self.apoloItemSelected = self.apoloList[indexPath.row]
        }
        
        performSegue(withIdentifier: "segueToDetailApolo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}

extension ApoloListViewController
{
    func getSavedList()
    {
        let apoloListFromSaved = ApoloModel.loadApoloList()
        
        if apoloListFromSaved.count > 0
        {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            self.apoloList = apoloListFromSaved
            
            self.apoloListTableView.reloadData()
            
            print("LISTA CARGADA DE LA MEMORIA")
        }
        else
        {
            self.getApoloList()
            
            print("CARGANDO LISTA DESDE EL API")
        }
    }
    
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
                    let apoloKeywords = apoloList[i].apoloDataList![0].apoloDataKewords ?? []
                    var apoloImageUrl = ""
                    
                    if let apoloLink = apoloList[i].apoloLinks?.filter({ $0.apoloLinkRel == "preview" }).first
                    {
                        apoloImageUrl = apoloLink.apoloLinkUrl ?? ""
                    }
                    
                    apoloList[i].apoloTitle = apoloTitle
                    apoloList[i].apoloDesc = apoloDesc
                    apoloList[i].apoloKeywords = apoloKeywords
                    apoloList[i].apoloImageUrl = apoloImageUrl
                    apoloList[i].apoloIsFavorite = false
                }
                
                self.apoloList = apoloList
                ApoloModel.saveApoloList(apoloList: self.apoloList)
                
                self.apoloListTableView.reloadData()
            }
            
            if let error = error
            {
                print("Error al intentar traer la lista: \(error.localizedDescription)")
            }
        }
    }
}

extension ApoloListViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segueToDetailApolo"
        {
            let detailApoloViewController = segue.destination as! DetailApoloViewController
            detailApoloViewController.apoloItem = self.apoloItemSelected
        }
    }
}

