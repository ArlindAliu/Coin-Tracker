//
//  FavoritetController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/13/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage
//Klasa permbane tabele kshtuqe duhet te kete
//edhe protocolet per tabela
class FavoritetController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var favouriteCoinArray : [CoinCellModel] = [CoinCellModel]()
    var selectedCoin: CoinCellModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        request.returnsObjectsAsFaults = false
        
        
        do {
            let rezultati = try context.fetch(request)
            if rezultati.count > 0 {
                for item in rezultati as! [NSManagedObject]{
                    
                    
                    let coin = CoinCellModel(coinName: item.value(forKey: "coinName") as! String, coinSymbol: item.value(forKey: "coinSymbol")as! String, coinAlgo: item.value(forKey: "coinAlgo") as! String, totalSuppy: item.value(forKey: "totalSupply") as! String, imagePath: item.value(forKey: "imagePath")as! String)
                    favouriteCoinArray.append(coin)
                    
                }
                tableView.reloadData()
            } else {
                print("Nuk ka elemente")
            }
            
            
        }
            
        catch  {
            print("Gabim gjate leximit")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        cell.imgFotoja.af_setImage(withURL: URL(string: favouriteCoinArray[indexPath.row].coinImage())!)
        cell.lblAlgoritmi.text = favouriteCoinArray[indexPath.row].coinAlgo
        cell.lblEmri.text = favouriteCoinArray[indexPath.row].coinName
        cell.lblSymboli.text = favouriteCoinArray[indexPath.row].coinSymbol
        cell.lblTotali.text = favouriteCoinArray[indexPath.row].totalSuppy
        print(favouriteCoinArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteCoinArray.count
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            print("deleted")
//        }
//
//        self.tableView.deleteRows(at: [indexPath], with: .automatic)
//    }
   
    @IBAction func kthehuBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            favouriteCoinArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

}
