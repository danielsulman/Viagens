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
            
            //Exibe anotacao com os dados do endereco
            let anotacao = MKPointAnnotation()
            
            anotacao.coordinate.latitude = coordenadas.latitude
            anotacao.coordinate.longitude = coordenadas.longitude
            anotacao.title = "Pressionei aqui"
            anotacao.subtitle = "Estou aqui"
            
            map.addAnnotation(anotacao)
            
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
