//
//  ViewController.swift
//  Viagens
//
//  Created by Daniel Sulman de Albuquerque Eloi on 02/05/17.
//  Copyright © 2017 Daniel Sulman de Albuquerque Eloi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var locaisViagens: [Dictionary<String,String>] = []
    var controleNavegacao : String = "adicionar"


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controleNavegacao = "adicionar"
        atualizarViagens()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locaisViagens.count
    }
    
    //Removendo itens da tabela
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            ArmazenamentoDados().removerViagem(indice: indexPath.row)
            atualizarViagens()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controleNavegacao = "listar"
        performSegue(withIdentifier: "map", sender: indexPath.row)
    }
    
    func atualizarViagens(){
        locaisViagens = ArmazenamentoDados().listarViagens()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = locaisViagens[indexPath.row]["local"]
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map"{
            let viewControllerDestino = segue.destination as! Mapa
            
            if self.controleNavegacao == "listar"{
                if let indiceRecuperado = sender{
                    let indice = indiceRecuperado as! Int
                    viewControllerDestino.viagem = locaisViagens[indice]
                    viewControllerDestino.indiceSelecionado = indice
                }   
            }else{
                viewControllerDestino.viagem = [:]
                viewControllerDestino.indiceSelecionado = -1
            }
            
            if let indiceRecuperado = sender{
                
            }
            
        }

    }
}

