//
//  SignUpViewModel.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import Foundation

class SignUpViewModel: ObservableObject {
    
    // States
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmVisible: Bool = false
    
    @Published var selectedMonth: String = "Enero"
    @Published var selectedDay: String = "1"
    @Published var selectedYear: String = "2023"
    @Published var selectedBloodType = "Selecciona tu tipo de sangre"
    @Published var countryCode = ""
    @Published var phoneNumber = ""
    @Published var nombreCompleto: String = ""

   
    // Arrays
    let months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    let bloodTypes = ["Selecciona tu tipo de sangre", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    let days = Array(1...31).map { "\($0)" }
    let years = Array(1900...2023).reversed().map { "\($0)" }
    
    // Creas dos variables más por si se comete un error
    @Published var messageAlert = ""
    @Published var showAlert = false
    
    // Closure que se llamará al completar el perfil
    var onProfileComplete: (() -> Void)?
    
    var signUpRequirement: SignUpRequirementProtocol
    
    init(signUpRequirement: SignUpRequirementProtocol = SignUpRequirement.shared) {
        self.signUpRequirement = signUpRequirement
    }
    
    func obtenerNumeroDelMes() -> Int {
        if let indice = months.firstIndex(of: selectedMonth) {
            return indice + 1
        } else {
            print("Mes no encontrado en el array.")
            return 0
        }
    }
    
    @MainActor
    func validarDatosStep1() {
        if self.email.isEmpty || self.username.isEmpty {
            self.messageAlert = "Correo o username vacío. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
    }
    
    @MainActor
    func validarDatosStep2() {
        if (self.countryCode.isEmpty || self.phoneNumber.isEmpty || self.selectedBloodType == "Selecciona tu tipo de sangre" || self.nombreCompleto.isEmpty) {
            self.messageAlert = "Falta de llenar algún dato. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
    }
    
    @MainActor
    func registrarUsuario() async {
        if (self.password.isEmpty || self.confirmPassword.isEmpty) {
            self.messageAlert = "Alguna de las dos contraseñas está vacía. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
        
        if (self.password != self.confirmPassword) {
            self.messageAlert = "Las contraseñas no son iguales. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
        
        let numeroMes = obtenerNumeroDelMes()
        let fechaNacimiento = "\(selectedYear)-\(numeroMes)-\(selectedDay)"
        
        let numeroEmergencia = "+" + self.countryCode + self.phoneNumber
        
        let usuarioNuevo = UserNuevo(username: self.username, password: self.confirmPassword, nombre: nombreCompleto, email: self.email, fechaNacimiento: fechaNacimiento, tipoSangre: self.selectedBloodType, numeroEmergencia: numeroEmergencia)
        
        let responseCode = await self.signUpRequirement.registrarUsuario(UserDatos: usuarioNuevo)
        
        if (responseCode != 201){
            self.messageAlert = "Hubo un error al registrar al usuario."
            self.showAlert = true
        }
    }
    
    @MainActor
    func validarCompletarDatos1() {
        if (self.username.isEmpty) {
            self.messageAlert = "El username se encuentra vacío. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
    }
    
    @MainActor
    func completarRegistro() async {
        
        if (self.countryCode.isEmpty || self.phoneNumber.isEmpty || self.selectedBloodType == "Selecciona tu tipo de sangre") {
            self.messageAlert = "Falta de llenar algún dato. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
        
        let numeroMes = obtenerNumeroDelMes()
        let fechaNacimiento = "\(selectedYear)-\(numeroMes)-\(selectedDay)"
        
        let numeroEmergencia = "+" + self.countryCode + self.phoneNumber
        
        let usuarioNuevo = UserExterno(username: self.username, fechaNacimiento: fechaNacimiento, tipoSangre: self.selectedBloodType, numeroEmergencia: numeroEmergencia)
        
        let responseCode = await self.signUpRequirement.completarPerfil(UserDatos: usuarioNuevo)
        
        if (responseCode == 200 || responseCode == 201){
            // Llamar al closure para notificar el éxito
            self.onProfileComplete?()
        } else {
            self.messageAlert = "Hubo un error al completar el registro."
            self.showAlert = true
        }
    }
    
    @MainActor
    func GoogleLogin() async {
        let responseStatus = await self.signUpRequirement.GoogleLogin()
        
        if (responseStatus == 500) {
            self.messageAlert = "Error al iniciar sesión con Google. Favor intentar de nuevo"
            self.showAlert = true
            // No mostrar error si se cancelo.
        } else if (responseStatus == -1) {
            self.showAlert = false
        }
    }
}