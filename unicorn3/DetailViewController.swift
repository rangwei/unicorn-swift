//
//  DetailViewController.swift
//  unicorn3
//
//  Created by Rang, Winters on 2019/8/13.
//  Copyright © 2019 Rang, Winters. All rights reserved.
//

import SAPFiori

class DetailViewController: UITableViewController, SAPFioriLoadingIndicator  {
    var loadingIndicator: FUILoadingIndicatorView?
    
    var unicorn: Unicorn?
    
    var fundings = [FundingRound]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Table
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        self.updateTable()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fundings.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objectCell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath)
            as! FUIObjectTableViewCell
        
        // Configure the cell...
        objectCell.headlineText = fundings[indexPath.row].short_name
        objectCell.subheadlineText = fundings[indexPath.row].date
        
        objectCell.statusText = fundings[indexPath.row].valuation

        objectCell.accessoryType = .disclosureIndicator
        objectCell.splitPercent = CGFloat(0.3)
        
        
        
        return objectCell
     }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func updateTable() {
        self.showFioriLoadingIndicator()
        DispatchQueue.global().async {
            self.loadData {
                self.hideFioriLoadingIndicator()
            }
        }
    }
    
    private func loadData(completionHandler: @escaping() -> Void) {
        self.requestEntities { error in
            defer {
                completionHandler()
            }
            
            if let error = error {
                print("error")
                AlertHelper.displayAlert(with: "Create Entry failed", error: error, viewController: self)
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    private func requestEntities( completionHandler: @escaping (Error?) -> Void) {
        
        if let uname = unicorn?.name {
            let url = UnicornAPIURLs.instance.getUnicorn(name: uname)
            
            guard let loanUrl = URL(string: url) else {
                return
            }
            
            let request = URLRequest(url: loanUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                
                if let error = error {
                    completionHandler(error)
                    return
                }
                
                if let data = data {

                    self.fundings = self.parseJsonData(data: data)
                    
                    completionHandler(error)
                }
            })
            task.resume()
        }
        
    }
    
    
    func parseJsonData(data: Data) -> [FundingRound] {
        
        var fundings = [FundingRound]()
        let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let jsonData = jsonResult as? [String: Any] {
            fundings = FundingRound.getFundings(jsonData)
        }
        return fundings

    }
}

