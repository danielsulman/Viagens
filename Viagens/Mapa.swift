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
    var indiceSelecionado : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let indice = indiceSelecionado {
            //adicionando
            if indice == -1{
                configuraGerenciadorLocalizacao()
            //listando
            } else{
                exibirAnotacao(viagem: viagem)
            }
        }

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
                }else{
                    print(erro!)
                }
            })
        }
    }
    
    func exibirAnotacao(viagem : Dictionary<String,String>){
        //Exibe anotacao com os dados do endereco
        if let localViagem = viagem["local"]{
            if let longitudeS = viagem["longitude"] {
                if let latitudeS = viagem["latitude"]{
                    if let latitude = Double(latitudeS){
                        if let longitude = Double(longitudeS){
                            
                            //Exibe o local
                            let localizacao = CLLocationCoordinate2DMake(latitude, longitude)
                            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                            let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, span)
                            
                            self.map.setRegion(regiao, animated: true)
                            
                            //Adiciona anotacao
                            let anotacao = MKPointAnnotation()
                            
                            anotacao.coordinate.latitude = latitude
                            anotacao.coordinate.longitude = longitude
                            anotacao.title = localViagem
                            
                            self.map.addAnnotation(anotacao)
                        }
                    }
                    
                }
            }
        }
        
        
    }
    func salvarAnotacao(latitude: CLLocationDegrees, longitude: CLLocationDegrees, titutlo: String!){
        //Exibe anotacao com os dados do endereco
        let anotacao = MKPointAnnotation()
        
        anotacao.coordinate.latitude = latitude
        anotacao.coordinate.longitude = longitude
        anotacao.title = titutlo
        
        
        self.map.addAnnotation(anotacao)
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
