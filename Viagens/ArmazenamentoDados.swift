//
//  ArmazenamentoDados.swift
//  Viagens
//
//  Created by Daniel Sulman de Albuquerque Eloi on 03/05/17.
//  Copyright © 2017 Daniel Sulman de Albuquerque Eloi. All rights reserved.
//

import UIKit

class ArmazenamentoDados{
    
    //Salvar dados no dispositivo
    
    let chaveArmazenamento = "locaisViagem"
    var viagens : [ Dictionary<String, String>] = []
    
    func getDefaults() -> UserDefaults{
        return UserDefaults.standard
    }
    
    func salvarViagem( viagem: Dictionary<String,String>){
        
        viagens = listarViagens()
        viagens.append(viagem)
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        getDefaults().synchronize()
        
    }
    
    func listarViagens() -> [Dictionary<String, String>]{
        
        let dados = getDefaults().object(forKey: chaveArmazenamento)
        if dados != nil{
            return dados as! Array
        }else{
            return []
        }
    }
    
    func removerViagem(indice: Int){
        
        viagens = listarViagens()
        viagens.remove(at: indice)
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        getDefaults().synchronize()
        
    }
    
}
