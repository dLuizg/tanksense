
/*
include <WiFi.h>
include <FirebaseESP32.h>
include <ArduinoJson.h>


// Configurações WiFi
#define WIFI_SSID "Oliveira 2.4GHZ"
#define WIFI_PASSWORD "271523mae"


// Configurações Firebase
#define FIREBASE_HOST "https://tanksense---v2-default-rtdb.firebaseio.com"  // SEM a barra no final!
#define FIREBASE_AUTH "XALK5M3Yuc7jQgS62iDXpnAKvsBJEWKij0hR02tx"


// Pinos do sensor ultrassônico
#define TRIG_PIN 2
#define ECHO_PIN 4


// Configuração do tanque
const float alturaTotalTanque = 33.0; // cm
const float descontoBase = 5.0;       // cm da base que não conta
const float alturaUtil = alturaTotalTanque - descontoBase;  // altura útil = 28 cm


// Objetos Firebase
FirebaseData fbdo;
FirebaseConfig config;
FirebaseAuth auth;


// Função para medir distância
float medirDistancia() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);


  long duracao = pulseIn(ECHO_PIN, HIGH, 30000); // timeout 30ms
  if (duracao == 0) return -1; // erro de leitura


  float distancia = duracao * 0.034 / 2.0;  // cm
  return distancia;
}


// Função para conectar ao WiFi
void conectarWiFi() {
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Conectando ao WiFi");
 
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
 
  Serial.println();
  Serial.print("Conectado com IP: ");
  Serial.println(WiFi.localIP());
}


// Função para enviar dados ao Firebase
void enviarParaFirebase(float distancia, float nivel, float porcentagem, String status) {
  // Criar timestamp único
  String timestamp = String(millis());
 
  // Criar objeto JSON com os dados
  FirebaseJson json;
  json.set("distancia_fundo_tanque", distancia);
  json.set("nivel_tanque", nivel);
  json.set("porcentagem_tanque", porcentagem);
  json.set("status_tanque", status);
  json.set("Id_leitura", timestamp);
  
 
  // Enviar dados para o Firebase (criar novo nó)
  String path = "/tanque/leituras/" + timestamp;
  if (Firebase.setJSON(fbdo, path, json)) {
    Serial.println("Dados enviados para Firebase com sucesso!");
  } else {
    Serial.println("Falha ao enviar dados:");
    Serial.println(fbdo.errorReason());
  }
 
  // Atualizar também a última leitura
  FirebaseJson jsonUltimo;
  jsonUltimo.set("distancia_cm", distancia);
  jsonUltimo.set("nivel_cm", nivel);
  jsonUltimo.set("porcentagem", porcentagem);
  jsonUltimo.set("status", status);
  jsonUltimo.set("timestamp", timestamp);
  jsonUltimo.set("unidade", "cm");
 
  if (Firebase.setJSON(fbdo, "/tanque/ultima_leitura", jsonUltimo)) {
    Serial.println("Última leitura atualizada!");
  } else {
    Serial.println("Falha ao atualizar última leitura:");
    Serial.println(fbdo.errorReason());
  }
}


void setup() {
  Serial.begin(115200);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);


  Serial.println("=== Monitoramento do Tanque ===");
 
  // Conectar ao WiFi
  conectarWiFi();
 
  // Configurar Firebase (NOVA FORMA)
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
 
  // Inicializar Firebase
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
 
  // Configurações adicionais do Firebase
  Firebase.setReadTimeout(fbdo, 1000 * 60);
  Firebase.setwriteSizeLimit(fbdo, "tiny");
 
  Serial.println("Firebase inicializado com sucesso!");
}


void loop() {
  float distancia = medirDistancia();
  if (distancia < 0) {
    Serial.println("Falha na leitura do sensor");
    delay(2000);
    return;
  }


  // Calcula nível real do líquido
  float nivel = alturaUtil - (distancia - descontoBase);
  if (nivel < 0) nivel = 0;
  if (nivel > alturaUtil) nivel = alturaUtil;


  // Calcula porcentagem
  float porcentagem = (nivel / alturaUtil) * 100;


  // Determina status
  String status;
  if (porcentagem > 75) {
    status = "Alto";
  } else if (porcentagem > 30) {
    status = "Médio";
  } else {
    status = "Baixo";
  }


  // Saída no terminal
  Serial.println("\n");
  Serial.println("---------------");
  Serial.println("- TANKSENSE -");
  Serial.print("Porcentagem do tanque: ");
  Serial.print(porcentagem);
  Serial.println(" %");


  Serial.print("Distância sensor / fundo tanque: ");
  Serial.print(distancia);
  Serial.println(" cm");


  Serial.print("Status: ");
  Serial.println(status);


  // Enviar dados para o Firebase
  enviarParaFirebase(distancia, nivel, porcentagem, status);


  delay(2000); // leitura a cada 2 segundos
}

*/
