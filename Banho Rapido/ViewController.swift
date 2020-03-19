//
//  ViewController.swift
//  Banho Rapido
//
//  Created by José Henrique Fernandes Silva on 02/03/20.
//  Copyright © 2020 José Henrique Fernandes Silva. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var labelSelecioneVazao1: UILabel!
    @IBOutlet var labelSelecioneVazao2: UILabel!
    @IBOutlet var botaoInformacaoVazao: UIButton!
    @IBOutlet var pickerTipoChuveiro: UIPickerView!
    @IBOutlet var botaoIniciarBanho: UIButton!
    @IBOutlet var botaoMaisInformacao: UIButton!
    @IBOutlet var botaoMaisInformacao2: UIButton!
    @IBOutlet var labelCronometro: UILabel!
    @IBOutlet var botaoTerminarBanho: UIButton!
    @IBOutlet var textFieldVazao: UITextField!
    @IBOutlet var viewTelaCronometro: UIView!
    @IBOutlet var labelTipoChuveiro: UILabel!
    @IBOutlet var viewTelaInformacoesBanho: UIView!
    @IBOutlet var labelInforTempoGasto: UILabel!
    @IBOutlet var labelInfoLitosGastos: UILabel!
    @IBOutlet var viewInformacoesVazao: UIView!
    @IBOutlet var viewMaisInformacoes: UIView!
    @IBOutlet var viewBoxInfoBanho: UIView!
    @IBOutlet var labelPrecisaoVazao: UILabel!
    @IBOutlet var scPrecisaoVazao: UISegmentedControl!
    
    var escolhaChuveiroEletrico: String = ""
    var estadoBotaoIniciarTerminarBanho = false
    var tempoBanhoMinSeg: [Int] = [0, 0]
    var quantidadeGastaAguaBanho: Double = 0
    let escolhasChuveiro = ["Sim", "Não"]
    var estadoSegmentedControl = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldVazao.delegate = self
        pickerTipoChuveiro.dataSource = self
        pickerTipoChuveiro.delegate = self
        viewInformacoesVazao.layer.cornerRadius = 20
        viewMaisInformacoes.layer.cornerRadius = 20
        viewBoxInfoBanho.layer.cornerRadius = 20
        labelTipoChuveiro.alpha = 0.4
        pickerTipoChuveiro.alpha = 0.4
        pickerTipoChuveiro.isUserInteractionEnabled = false
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default

        _ = UNNotificationRequest(identifier: "id", content: content, trigger: nil)
    }
    
    @IBAction func clicarIniciar() {
        esconderComponentesTelaPrincipal()
        mostrarComponentesCronometro()
        //Iniciar teste codigo timer
        iniciaTimer()
    }
    
    @IBAction func clicarTerminar() {
        // Troca de 'tela'
        estadoBotaoIniciarTerminarBanho = false
        esconderComponetesCronometro()
        mostrarInformacoesBanho()
        
        // Parar cronometro
        timer.invalidate()
        segundos = 0
        let auxiliarStringMinutosSegundos = timeString(time: TimeInterval(segundos))
        labelCronometro.text = String(format: "%02i:%02i", auxiliarStringMinutosSegundos[0], auxiliarStringMinutosSegundos[1])
        
        // Calcular gasto de agua
        let posiaoPickerTipoChuveiro: Int = pickerTipoChuveiro.selectedRow(inComponent: 0)
        print(posiaoPickerTipoChuveiro)
        var valorTextFieldVazao: Double = 0
        if !(textFieldVazao.text ?? "").isEmpty {
            valorTextFieldVazao = Double (textFieldVazao.text!)!
        }
        let chuveiroInformacoes = Chuveiro(vazao: valorTextFieldVazao, eletrico: escolhasChuveiro[pickerTipoChuveiro.selectedRow(inComponent: 0)], precisao: estadoSegmentedControl)
        let quantidadeGastaAgua = chuveiroInformacoes.calculaGastoAgua(minutos: tempoBanhoMinSeg[0], segundos: tempoBanhoMinSeg[1])
        labelInforTempoGasto.text = "E passou \(tempoBanhoMinSeg[0]) min e \(tempoBanhoMinSeg[1]) seg no banho"
        labelInfoLitosGastos.text = "Você gastou \(round(quantidadeGastaAgua)) litros de água"
        
    }
    
    @IBAction func clicarBotaoTelaInicial() {
        esconderComponetesCronometro()
        esconderInformacoesBanho()
        mostrarComponentesTelaPrincipal()
    }

    @IBAction func cliclarBotaoInfoVazao() {
        viewInformacoesVazao.isHidden = false
        botaoIniciarBanho.alpha = 0.4
        pickerTipoChuveiro.alpha = 0.4
        labelTipoChuveiro.alpha = 0.4
        textFieldVazao.alpha = 0.4
        botaoMaisInformacao.alpha = 0.4
        botaoMaisInformacao2.alpha = 0.4
        labelPrecisaoVazao.alpha = 0.4
        scPrecisaoVazao.alpha = 0.4
    }
    
    @IBAction func clicarFecharInfoVazao() {
        viewInformacoesVazao.isHidden = true
        botaoIniciarBanho.alpha = 1
        pickerTipoChuveiro.alpha = 1
        labelTipoChuveiro.alpha = 1
        textFieldVazao.alpha = 1
        botaoMaisInformacao.alpha = 1
        botaoMaisInformacao2.alpha = 1
        labelPrecisaoVazao.alpha = 1
        scPrecisaoVazao.alpha = 1
    }
    
    @IBAction func gestoTocouTela(_ sender: Any) {
        textFieldVazao.endEditing(true)
    }
    @IBAction func clicarMaisInformacoesTexto() {
        viewMaisInformacoes.isHidden = false
        botaoIniciarBanho.alpha = 0.4
        labelTipoChuveiro.alpha = 0.4
        textFieldVazao.alpha = 0.4
        pickerTipoChuveiro.alpha = 0.4
        labelSelecioneVazao1.alpha = 0.4
        labelSelecioneVazao2.alpha = 0.4
        botaoInformacaoVazao.alpha = 0.4
        labelPrecisaoVazao.alpha = 0.4
        scPrecisaoVazao.alpha = 0.4
    }
    @IBAction func cliclarMaisInformacoesIcone() {
        //mostrarMaisInformacoes()
        viewMaisInformacoes.isHidden = false
        botaoIniciarBanho.alpha = 0.4
        labelTipoChuveiro.alpha = 0.4
        textFieldVazao.alpha = 0.4
        pickerTipoChuveiro.alpha = 0.4
        labelSelecioneVazao1.alpha = 0.4
        labelSelecioneVazao2.alpha = 0.4
        botaoInformacaoVazao.alpha = 0.4
        labelPrecisaoVazao.alpha = 0.4
        scPrecisaoVazao.alpha = 0.4
    }
    @IBAction func clicarFecharMaisInformacoes() {
        //esconderMaisInformacoes()
        viewMaisInformacoes.isHidden = true
        botaoIniciarBanho.alpha = 1
        labelTipoChuveiro.alpha = 1
        textFieldVazao.alpha = 1
        pickerTipoChuveiro.alpha = 1
        labelSelecioneVazao1.alpha = 1
        labelSelecioneVazao2.alpha = 1
        botaoInformacaoVazao.alpha = 1
        labelPrecisaoVazao.alpha = 1
        scPrecisaoVazao.alpha = 1
    }
    @IBAction func clicouLinkVazao() {
        UIApplication.shared.open(URL(string: "https://www.youtube.com/watch?v=nZ12dCRh-bM")! as URL, options: [:], completionHandler: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldVazao.endEditing(true)
    }
    
    @IBAction func clicouSCPrecisaoVazao(_ sender: Any) {
        estadoSegmentedControl = scPrecisaoVazao.selectedSegmentIndex
        if estadoSegmentedControl == 0 {
            // estadoSegmentedControl == Sim
            labelTipoChuveiro.alpha = 0.4
            pickerTipoChuveiro.alpha = 0.4
            pickerTipoChuveiro.isUserInteractionEnabled = false
        } else {
            // estadoSegmentedControl == Não
            labelTipoChuveiro.alpha = 1
            pickerTipoChuveiro.alpha = 1
            pickerTipoChuveiro.isUserInteractionEnabled = true
        }
        
    }
    
    /// Configuracao picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return escolhasChuveiro.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return escolhasChuveiro[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        escolhaChuveiroEletrico = escolhasChuveiro[row]
        print(escolhaChuveiroEletrico)
    }
    
    /// Confuguracao de telas
    func esconderComponentesTelaPrincipal(){
        // Esconder label (Selecione vazao)
        labelSelecioneVazao1.isHidden = true
        labelSelecioneVazao2.isHidden = true
        // Esconder botao de informacao (vazao)
        botaoInformacaoVazao.isHidden = true
        // Esconder picker
        pickerTipoChuveiro.isHidden = true
        // Esconder botao (iniciar banho)
        botaoIniciarBanho.isHidden = true
        // Esconder botao (mais informacao)
        botaoMaisInformacao.isHidden = true
        botaoMaisInformacao2.isHidden = true
        // Mudar cor da tela para verde
        //self.view.backgroundColor = UIColor.green
        labelTipoChuveiro.isHidden = true
        textFieldVazao.isHidden = true
        labelPrecisaoVazao.isHidden = true
        scPrecisaoVazao.isHidden = true
    }
    
    func mostrarComponentesTelaPrincipal(){
        // Mostrar label (Selecione vazao)
        labelSelecioneVazao1.isHidden = false
        labelSelecioneVazao2.isHidden = false
        // Mostrar botao de informacao (vazao)
        botaoInformacaoVazao.isHidden = false
        // Mostrar picker
        pickerTipoChuveiro.isHidden = false
        // Mostrar botao iniciar banho
        botaoIniciarBanho.isHidden = false
        // Mostrar botao mais informacoes
        botaoMaisInformacao.isHidden = false
        botaoMaisInformacao2.isHidden = false
        
        labelTipoChuveiro.isHidden = false
        textFieldVazao.isHidden = false
        labelPrecisaoVazao.isHidden = false
        scPrecisaoVazao.isHidden = false
    }
    
    func mostrarComponentesCronometro(){
        // Mostrar label (minutos:segundos)
        // Mostrar botao (terminar)
        viewTelaCronometro.isHidden = false
    }
    
    func esconderComponetesCronometro(){
        // Esconder label (minutos:segundos)
        // Esconder botao (terminar)
        // Mudar cor da tela para azul
        viewTelaCronometro.isHidden = true
    }
    
    func mostrarInformacoesBanho(){
        viewTelaInformacoesBanho.isHidden = false
    }
    
    func esconderInformacoesBanho() {
        viewTelaInformacoesBanho.isHidden = true
    }
    
    
    ///Código teste de cronometro:
    /// (https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f)
    var segundos = 0
    var timer = Timer()
    func iniciaTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.atualizaTimer)), userInfo: nil, repeats: true)
    }
    @objc func atualizaTimer() {
        segundos += 1
        let tempoMinutosSegundos = timeString(time: TimeInterval(segundos))
        labelCronometro.text = String(format:"%02i:%02i", tempoMinutosSegundos[0], tempoMinutosSegundos[1])
        tempoBanhoMinSeg[0] = tempoMinutosSegundos[0]
        tempoBanhoMinSeg[1] = tempoMinutosSegundos[1]
    }
    func timeString(time: TimeInterval) -> [Int] {
        let minutos = Int(time) / 60 % 60
        let segundos = Int(time) % 60
        if(segundos < 5){
            viewTelaCronometro.backgroundColor = UIColor.systemGreen
            botaoTerminarBanho.tintColor = UIColor.systemGreen
        } else if(segundos < 10){
            if segundos == 5 {
                AudioServicesPlaySystemSound(SystemSoundID(1005))
            }
            viewTelaCronometro.backgroundColor = UIColor.systemYellow
            botaoTerminarBanho.tintColor = UIColor.systemYellow
        } else {
            if segundos == 10 || segundos%20 == 0 {
                AudioServicesPlaySystemSound(SystemSoundID(1005))
            }
            viewTelaCronometro.backgroundColor = UIColor.systemRed
            botaoTerminarBanho.tintColor = UIColor.systemRed
        }
        return [minutos, segundos]
    }
    
}
