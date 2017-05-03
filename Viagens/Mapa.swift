//
//  mapa.swift
//  Viagens
//
//  Created by Daniel Sulman de Albuquerque Eloi on 02/05/17.
//  Copyright © 2017 Daniel Sulman de Albuquerque Eloi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Mapa: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var map: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var viagem : Dictionary<String,String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuraGerenciadorLocalizacao()
    
        //Reconhecendo o toque na tela
        //: significa que será passado um parametro
        let reconheceGesto = UILongPressGestureRecognizer(target: self, action: #selector(Mapa.marcar(gesture:)))
        reconheceGesto.minimumPressDuration = 2 //Tempo em segundo
        
        map.addGestureRecognizer(reconheceGesto)
        
    }
    //O parametro passado contém as informações sobre o local pressionado
    func marcar(gesture: UIGestureRecognizer){
        //Captura exatamente quando se inicia o toque sobre a tela
        if gesture.state == UIGestureRecognizerState.began{
            let pontoSelecionado = gesture.location(in: self.map)
            let coordenadas = map.convert(pontoSelecionado, toCoordinateFrom: self.map)
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)

            var localCompleto = "Endereço não encontrado"
            //Recupera o endereço pressionado
            CLGeocoder().reverseGeocodeLocation(localizacao, completionHandler: { (local, erro) in
                if erro == nil{
                    if let dadosLocal = local?.first{
                        if let nomeLocal = dadosLocal.name{
                            localCompleto = nomeLocal
                        }else{
                            if let endereco = dadosLocal.thoroughfare{
                                localCompleto = endereco
                            }
                        }
                    }
                    //Salvar dados no dispositivo
                    self.viagem = ["local": localCompleto, "latitude": String(coordenadas.latitude), "longitude": String(coordenadas.longitude)]
                    ArmazenamentoDados().salvarViagem(viagem: self.viagem)
                    print(ArmazenamentoDados().listarViagens())
                    
                    //Exibe anotacao com os dados do endereco
                    let anotacao = MKPointAnnotation()
                    
                    anotacao.coordinate.latitude = coordenadas.latitude
                    anotacao.coordinate.longitude = coordenadas.longitude
                    anotacao.title = localCompleto

                    
                    self.map.addAnnotation(anotacao)
                    
                }else{
                    print(erro)
                }
            })
            
            
            
        }
        
    }
    func configuraGerenciadorLocalizacao(){
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
    //Caso o usuário não autorize, mostrar o caminho da tela de configurações
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            let alertaController = UIAlertController(title: "Permissão de localização", message: "Necessário permissão para a sua localização", preferredStyle: .alert)
            let acaoConfiguracao = UIAlertAction(title: "Abrir configuração", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alertaController.addAction(acaoConfiguracao)
            alertaController.addAction(acaoCancelar)
            
            present(alertaController, animated: true, completion: nil)
        }
    }
    
    
    
    
}
