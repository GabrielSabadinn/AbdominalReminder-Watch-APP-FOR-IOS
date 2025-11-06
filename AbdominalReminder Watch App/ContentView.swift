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
            
            // Botão de teste de notificação
            Button(action: {
                NotificationManager.shared.testNotification(reps: repsPerSession)
            }) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.green.opacity(0.7)))
            }
            .buttonStyle(.plain)
            
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
            let interval = WorkoutData.getInterval()
    let reps = WorkoutData.getRepsPerSession()
    NotificationManager.shared.clearNotifications()
    NotificationManager.shared.scheduleNotification(interval: interval, reps: reps)
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
        VStack(spacing: 16) {
            Text("Configurações")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 4) {
                Text("Intervalo de Lembrete")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))

                Picker("", selection: $interval) {
                    ForEach([1,2,3,4,6], id: \.self) { h in
                        Text("\(h) hora\(h > 1 ? "s" : "")").tag(Double(h))
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 60)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Repetições por Sessão")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))

                Picker("", selection: $repsPerSession) {
                    ForEach([10,15,20,25,30,35,40,45,50,60,70,80,90,100,150,200], id: \.self) { reps in
                        Text("\(reps) reps").tag(reps)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 60)
            }

            HStack {
                Button("Cancelar") { dismiss() }
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Button("Salvar") {
                    WorkoutData.saveInterval(interval)
                    WorkoutData.saveRepsPerSession(repsPerSession)
                    NotificationManager.shared.clearNotifications()
                    NotificationManager.shared.scheduleNotification(interval: interval, reps: repsPerSession)
                    NotificationCenter.default.post(name: .init("WorkoutDataUpdated"), object: nil)
                    dismiss()
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding(.horizontal, 8)
        .background(Color.black.opacity(0.95))
        // SEM .onTapGesture
    }
}




#Preview {
    ContentView()
}
