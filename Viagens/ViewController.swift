//
//  ViewController.swift
//  Viagens
//
//  Created by Daniel Sulman de Albuquerque Eloi on 02/05/17.
//  Copyright © 2017 Daniel Sulman de Albuquerque Eloi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let dados: [String] = ["daniel", "teste"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dados.count
    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = dados[indexPath.row]
        
        return cell!
    }

}

