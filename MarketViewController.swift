//
//  MarketViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/4/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse

class MarketViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let homeImageView = UIImageView(image: #imageLiteral(resourceName: "market_navbar_icon"))
        self.navigationItem.titleView = homeImageView
        
        self.view.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
        self.tableView.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
    }

    var tableData =
    [
        
        [("gold_image", "0"), ("red_image", "0"), ("green_image", "0"), ("blue_image", "0"), ("dark_blue_image", "0"), ("purple_image", "0"), ("pink_image", "0"), ("maroon_image", "0")], // interface
        
        [("black_pet", "500"), ("blue_pet", "500"), ("brown_pet", "500"), ("green_pet", "500"), ("orange_pet", "500"), ("pink_pet", "500"), ("purple_pet", "500"), ("red_pet", "500"), ("white_pet", "500"), ("yellow_pet", "500"), ("gold_pet", "1500"), ("rainbow_pet", "1500")], // pets
        
        [("red_card", "100"), ("orange_card", "200"), ("yellow_card", "500"), ("green_card", "1000"), ("blue_card", "2000"), ("black_card", "5000")], // credit cards
        
        [("", "500"), ("", "500"), ("", "1000"), ("", "2000"), ("", "5000")], // pet accessories
        
    ]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "marketTableCell", for: indexPath) as! MarketTableViewCell
        
        cell.collectionView?.dataSource = cell
        cell.collectionView?.delegate = cell
        
        cell.collectionViewData = self.tableData[indexPath.section]
        
        cell.collectionView?.reloadData()
        
        cell.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        
        case 0:
            return "Interface"
        case 1:
            return "Pets"
        case 2:
            return "Credit Cards"
        case 3:
            return "Pet Accessories"
        default:
            return nil
            
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.white
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
