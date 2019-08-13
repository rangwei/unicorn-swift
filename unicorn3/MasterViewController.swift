//
//  MasterViewController.swift
//  unicorn3
//
//  Created by Rang, Winters on 2019/8/13.
//  Copyright © 2019 Rang, Winters. All rights reserved.
//

import SAPFiori

class MasterViewController: UITableViewController {
    
    let unicornURL = "http://localhost:3000/unicorns"
    
    //MARK: Properties
    var unicorns = [Unicorn]()

    var detailViewController: DetailViewController? = nil



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
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
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
    
    private func updateTable() {
        guard let loanUrl = URL(string: unicornURL) else {
            return
        }
        
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                self.unicorns = self.parseJsonData(data: data)
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
        })
        task.resume()
    }
    
    func parseJsonData(data: Data) -> [Unicorn] {
        var unicorns = [Unicorn]()
        
        let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        if let jsonDatas = jsonResult as? [AnyObject] {
            for jsonUnicorn in jsonDatas {
                let u = Unicorn()
                u.name = jsonUnicorn["name"] as? String
                u.country = jsonUnicorn["country"] as? String
                u.last_funding_on = jsonUnicorn[""] as? String
                u.total_equity_funding = jsonUnicorn["total_equity_funding"] as? Double
                u.founded_on = jsonUnicorn["founded_on"] as? Int
                u.category = jsonUnicorn["category"] as? String
                u.rumored = jsonUnicorn["rumored"] as? Int
                u.post_money_val = jsonUnicorn["post_money_val"] as? Double
                u.valuation_change = jsonUnicorn["valuation_change"] as? Int
                u.date_of_valuation = jsonUnicorn["date_of_valuation"] as? String
                unicorns.append(u)
            }
            
        }
        return unicorns
    }


}

