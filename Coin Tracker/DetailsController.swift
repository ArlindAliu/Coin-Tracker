//
//  ViewController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
class DetailsController: UIViewController {

    //selectedCoin deklaruar me poshte mbushet me te dhena nga
    //controlleri qe e thrret kete screen (Shiko ListaController.swift)
    var selectedCoin:CoinCellModel!
    
    //IBOutlsets jane deklaruar me poshte
    @IBOutlet weak var imgFotoja: UIImageView!
    @IBOutlet weak var lblDitaOpen: UILabel!
    @IBOutlet weak var lblDitaHigh: UILabel!
    @IBOutlet weak var lblDitaLow: UILabel!
    @IBOutlet weak var lbl24OreOpen: UILabel!
    @IBOutlet weak var lbl24OreHigh: UILabel!
    @IBOutlet weak var lbl24OreLow: UILabel!
    @IBOutlet weak var lblMarketCap: UILabel!
    @IBOutlet weak var lblCmimiBTC: UILabel!
    @IBOutlet weak var lblCmimiEUR: UILabel!
    @IBOutlet weak var lblCmimiUSD: UILabel!
    @IBOutlet weak var lblCoinName: UILabel!
    
    //APIURL per te marre te dhenat te detajume per coin
    //shiko: https://www.cryptocompare.com/api/ per detaje
    let APIURL = "https://min-api.cryptocompare.com/data/pricemultifull"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //brenda ketij funksioni, vendosja foton imgFotoja Outletit
        //duke perdorur AlamoFireImage dhe funksionin:
        //af_setImage(withURL:URL)
        imgFotoja.af_setImage(withURL: URL(string: selectedCoin.coinImage())!)
        //psh: imgFotoja.af_setImage(withURL: URL(string: selectedCoin.imagePath)!)
        //Te dhenat gjenerale per coin te mirren nga objeti selectedCoin
        
        
        //Krijo nje dictionary params[String:String] per ta thirrur API-ne
        var params : [String:String] = ["fsyms":selectedCoin.coinSymbol, "tsyms":"BTC,USD,EUR"]
        //parametrat qe duhet te jene ne kete params:
        
        //fsyms - Simboli i Coinit (merre nga selectedCoin.coinSymbol)
        //tsyms - llojet e parave qe na duhen: ""BTC,USD,EUR""
        
        //Thirr funksionin getDetails me parametrat me siper
        getDetails(params: params)
    }

    func getDetails(params:[String:String]){
        //Thrret Alamofire me parametrat qe i jan jap funksionit
        //dhe te dhenat qe kthehen nga API te mbushin labelat
        //dhe pjeset tjera te view
        Alamofire.request(APIURL, method: .get, parameters: params).responseData { (data) in
            if data.result.isSuccess{
                let coinJSON = JSON(data.result.value!)
                let coin = CoinDetailsModel(marketCap: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["MKTCAP"].stringValue , hourHigh: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["HIGH24HOUR"].stringValue, hourLow: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["LOW24HOUR"].stringValue, hourOpen: coinJSON["DISPLAY"]["TRUST"]["OPEN24HOUR"].stringValue, dayHigh: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["HIGHDAY"].stringValue, dayLow: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["LOWDAY"].stringValue, dayOpen: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["OPENDAY"].stringValue, priceEUR: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["PRICE"].stringValue, priceUSD: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["PRICE"].stringValue, priceBTC: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["BTC"]["PRICE"].stringValue)
                print(coin)
                
                self.lblMarketCap.text = coin.marketCap
                self.lblCmimiEUR.text = coin.priceEUR
                self.lblDitaOpen.text = coin.dayOpen
                self.lblDitaLow.text = coin.dayLow
                self.lbl24OreLow.text = coin.hourLow
                self.lblCmimiBTC.text = coin.priceBTC
                self.lblCmimiUSD.text = coin.priceUSD
                self.lblDitaHigh.text = coin.dayHigh
                self.lbl24OreHigh.text = coin.hourHigh
                self.lbl24OreOpen.text = coin.hourOpen
                self.lblCoinName.text = self.selectedCoin.coinName
            }
            
        }
       
    }
    
   
    @IBAction func ruajBtn(_ sender: Any) {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let coinFav = NSEntityDescription.insertNewObject(forEntityName: "Favourites", into: context)
        coinFav.setValue(selectedCoin.imagePath, forKey: "imagePath")
        coinFav.setValue(selectedCoin.coinAlgo, forKey: "coinAlgo")
        coinFav.setValue(selectedCoin.coinName, forKey: "coinName")
        coinFav.setValue(selectedCoin.coinSymbol, forKey: "coinSymbol")
        coinFav.setValue(selectedCoin.totalSuppy, forKey: "totalSupply")
        
        do {
            try context.save()
                
        } catch {
                print("gabim ne ruajtje")
    }
        
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    //IBAction mbylle - per butonin te gjitha qe mbyll ekranin
   
    
}

