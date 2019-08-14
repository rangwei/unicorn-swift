//
//  MasterViewController.swift
//  unicorn3
//
//  Created by Rang, Winters on 2019/8/13.
//  Copyright © 2019 Rang, Winters. All rights reserved.
//

import SAPFiori

class MasterViewController: UITableViewController, SAPFioriLoadingIndicator {
    
    
    //MARK: Properties
    var unicorns = [Unicorn]()
    
    var detailViewController: DetailViewController? = nil
    
    var loadingIndicator: FUILoadingIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //Table
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        self.updateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
//                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
                controller.unicorn = unicorns[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unicorns.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objectCell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath)
            as! FUIObjectTableViewCell
        
        // Configure the cell...
        objectCell.headlineText = unicorns[indexPath.row].name
        objectCell.subheadlineText = unicorns[indexPath.row].country
        objectCell.footnoteText = unicorns[indexPath.row].category
        
        //objectCell.descriptionText = "Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)"
        //objectCell.detailImage = UIImage() // TODO: Replace with your image
        //objectCell.detailImage?.accessibilityIdentifier = "Speed Mouse"
        
        objectCell.statusText = String(unicorns[indexPath.row].post_money_val ?? 0) + " USD"
        objectCell.substatusText = String(unicorns[indexPath.row].founded_on ?? 0)
        //objectCell.substatusLabel.textColor = .preferredFioriColor(forStyle: .positive)
        objectCell.accessoryType = .disclosureIndicator
        objectCell.splitPercent = CGFloat(0.3)
        
        
        
        return objectCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //        if editingStyle == .delete {
        //            objects.remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //        } else if editingStyle == .insert {
        //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        //        }
    }
    
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
        guard let url = URL(string: UnicornAPIURLs.instance.getUnicorns()) else {
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let error = error {
                completionHandler(error)
                return
            }
            
            if let data = data {
                self.unicorns = self.parseJsonData(data: data)
                
                completionHandler(error)
            }
        })
        task.resume()
    }
    
    
    func parseJsonData(data: Data) -> [Unicorn] {
        var unicorns = [Unicorn]()
        
        let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let dictionary = jsonResult as? [String: Any] {
            unicorns = Unicorn.getUnicorns(dictionary)
        }

        return unicorns
    }
    
}

