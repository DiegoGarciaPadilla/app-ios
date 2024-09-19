//
//  consultarAnuncio.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 04/09/24.
//

import SwiftUI

struct consultarAnuncio: View {
    @ObservedObject private var viewModel = AnuncioViewModel()
    @State private var showAddAnuncioView = false
    @State private var alertMessage = ""
    @State private var showDeleteConfirmation = false
    @State private var selectedAnuncio: Anuncio?
    @State private var showModifyView = false

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        Image("logoB&N")
                            .resizable()
                            .frame(width: 44, height: 35)
                            .padding(.leading)

                        Spacer()

                        Image(systemName: "bell")
                            .foregroundColor(.black)
                            .padding(.trailing)

                        Button(action: {
                            showAddAnuncioView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .padding(.trailing)
                        }
                    }
                    .padding()

                    Text("Anuncios")
                        .font(.title3)
                        .bold()
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.anuncios) { anuncio in
                            HStack {
                                Text(anuncio.icon)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.purple)
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(anuncio.titulo)
                                        .font(.headline)
                                        .fontWeight(.bold)

                                    Text(anuncio.contenido)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 8)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.white)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    selectedAnuncio = anuncio
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }

                                Button {
                                    selectedAnuncio = anuncio
                                    showModifyView = true
                                } label: {
                                    Label("Modificar", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color.white)
            .onAppear {
                viewModel.fetchAnuncios()
            }
            .sheet(isPresented: $showAddAnuncioView) {
                AnadirAnuncioView(viewModel: viewModel)
            }
            .sheet(isPresented: $showModifyView) {
                AnadirAnuncioView(viewModel: viewModel)
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("¿Seguro quieres eliminar el anuncio?"),
                    message: Text("Una vez eliminado no se podrá recuperar."),
                    primaryButton: .destructive(Text("Eliminar")) {
                        if let anuncio = selectedAnuncio {
                            viewModel.eliminarAnuncio(idAnuncio: anuncio.id)
                        }
                    },
                    secondaryButton: .cancel(Text("Cancelar"))
                )
            }
        }
    }
}


#Preview {
    consultarAnuncio()
}
