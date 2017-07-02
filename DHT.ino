#include "DHT.h"
String readString;
#define DHTPIN 2
int val;
#define DHTTYPE DHT11
int led = 3;
int Led = 4;
int H = 0;
int C = 0;
DHT dht(DHTPIN, DHTTYPE);
void setup() {
  Serial.begin(9600);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  dht.begin();
}
void loop() {
  while (Serial.available()) {
    delay(3);
    char c = Serial.read();
    readString += c;
    val = readString.toInt();
  }
  if (readString.length() > 0) {
    //Serial.println(readString);
    if (readString == "H")
    {
      digitalWrite(3, HIGH);
    }
    if (readString == "L")
    {
      digitalWrite(3, LOW);
    }
    if (readString == "h")
    {
      digitalWrite(4, HIGH);
    }
    if (readString == "l")
    {
      digitalWrite(4, LOW);
    }
    readString = "";
  }
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  float f = dht.readTemperature(true);
  if (isnan(h) || isnan(t) || isnan(f)) {
    return;
  }
  float hif = dht.computeHeatIndex(f, h);
  float hic = dht.computeHeatIndex(t, h, false);
  H = (int)h;
  C = (int)hic;
  Serial.print(H);
  Serial.print(",");
  Serial.println(C);
  delay(1000);
}
