//
//  ContentView.swift
//  AbdominalReminder Watch App
//
//  Created by Gabriel Belleboni Sabadin on 23/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var repsToday = WorkoutData.getDailyReps()
    @State private var repsPerSession = WorkoutData.getRepsPerSession()
    @State private var interval = WorkoutData.getInterval()
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Título
            Text("Abdominais")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
            
            // Contador
            Text("\(repsToday)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.cyan)
            
            Text("repetições hoje")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.gray.opacity(0.8))
            
            Spacer()
            
            // Botões
            HStack(spacing: 10) {
                // Botão para adicionar repetições
                Button(action: {
                    WorkoutData.addReps(repsPerSession)
                    repsToday = WorkoutData.getDailyReps()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(Circle().fill(Color.blue.opacity(0.7)))
                }
                .buttonStyle(.plain)
                
                // Botão para zerar contagem
                Button(action: {
                    WorkoutData.resetDailyReps()
                    repsToday = 0
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(Circle().fill(Color.red.opacity(0.7)))
                }
                .buttonStyle(.plain)
            }
            
            // Botão de configurações
            Button(action: {
                showingSettings = true
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.gray.opacity(0.3)))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(Color.black.opacity(0.95))
        .onAppear {
            if WorkoutData.shouldResetDailyReps() {
                WorkoutData.resetDailyReps()
                repsToday = 0
            }
            
            NotificationCenter.default.addObserver(
                forName: .init("WorkoutDataUpdated"),
                object: nil,
                queue: .main
            ) { _ in
                repsToday = WorkoutData.getDailyReps()
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("WorkoutDataUpdated"))) { _ in
            repsToday = WorkoutData.getDailyReps()
        }
    }
}

struct SettingsView: View {
    @State private var interval: Double = WorkoutData.getInterval()
    @State private var repsPerSession = WorkoutData.getRepsPerSession()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Título
                    Text("Configurações")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 4)
                    
                    // Picker para intervalo
                    VStack(spacing: 4) {
                        Text("Intervalo de Lembrete")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Picker("", selection: $interval) {
                            Text("1 hora").tag(1.0)
                            Text("2 horas").tag(2.0)
                            Text("3 horas").tag(3.0)
                            Text("4 horas").tag(4.0)
                            Text("6 horas").tag(6.0)
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 6)
                    
                    // Picker para repetições
                    VStack(spacing: 4) {
                        Text("Repetições por Sessão")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Picker("", selection: $repsPerSession) {
                            ForEach([10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 150, 200], id: \.self) { reps in
                                Text("\(reps) reps").tag(reps)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 6)
                    
                    // Botões
                    HStack(spacing: 8) {
                        Button(action: {
                            WorkoutData.saveInterval(interval)
                            WorkoutData.saveRepsPerSession(repsPerSession)
                            NotificationManager.shared.clearNotifications()
                            NotificationManager.shared.scheduleNotification(
                                interval: interval,
                                reps: repsPerSession
                            )
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Salvar")
                            }
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 6)
            }
            .background(Color.black.opacity(0.95))
            .navigationTitle("Config.")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
