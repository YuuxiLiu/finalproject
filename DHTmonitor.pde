import processing.serial.*;
Serial myPort; 
int[] v1, v2;
int n;
boolean record;
boolean Ledon;
boolean Ledon2;
int SD = 80;
int WD = 32;
void setup() {
  size(800, 600);  
  textFont(createFont("微软雅黑", 80));
  v1 = new int[9];
  v2 = new int[9];
  n = 0;
  record = false;
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  delay(2000);
}
void draw() {
  background(0);
  noFill();
  stroke(100, 255, 0);
  strokeWeight(1);
  rect(width*0.1, height*0.15, width*0.8, height*0.7);
  if (record)fill(55, 255, 0, 50);
  rect(width*0.69, height*0.88, width*0.08, height*0.06);
  if (!record) {
    fill(55, 255, 0, 50);
  } else {
    noFill();
  }
  rect(width*0.815, height*0.88, width*0.08, height*0.06);
  fill(200, 255, 100);
  textSize(20);
  text("开始          停止", width*0.705, height*0.925);
  for (int i=0; i<11; i++) {
    noFill();
    stroke(100, 200, 0);
    line(width*0.1, height*(0.15+i*0.07), width*0.9, height*(0.15+i*0.07));
    fill(100, 200, 0);
    textSize(18);
    if (i==0) {
      text("T/C", width*0.05, height*0.15);
      fill(150, 120, 250);
      text("H/%", width*0.92, height*0.15);
    } else {
      text(50-i*5, width*0.05, height*(0.15+i*0.07));
      fill(180, 120, 250);
      text(100-i*10, width*0.92, height*(0.15+i*0.07));
    }
  }
  fill(200, 255, 100);
  textSize(20);
  text("温 湿 度 实 时 监 控", width*0.375, height*0.925);
  strokeWeight(2);
  for (int i=0; i<n; i++) {
    stroke(200, 255, 100);
    float y = map(v1[i], 0, 50, height*0.85, height*0.15);
    point(width*(0.1+i*0.8/7), y);
    if (i>0) {
      float py = map(v1[i-1], 0, 50, height*0.85, height*0.15);
      line(width*(0.1+(i-1)*0.8/7), py, width*(0.1+i*0.8/7), y);
    }
    stroke(200, 100, 255);
    y = map(v2[i], 0, 100, height*0.85, height*0.15);
    point(width*(0.1+i*0.8/7), y);
    if (i>0) {
      float py = map(v2[i-1], 0, 100, height*0.85, height*0.15);
      line(width*(0.1+(i-1)*0.8/7), py, width*(0.1+i*0.8/7), y);
    }
  }
  textSize(16);
  strokeWeight(5);
  stroke(200, 255, 100);
  line(width*0.12, height*0.9, width*0.13, height*0.9);
  fill(200, 255, 100);
  text("温度", width*0.15, height*0.91);
  stroke(200, 100, 255);
  line(width*0.12, height*0.94, width*0.13, height*0.94);
  fill(200, 100, 255);
  text("湿度", width*0.15, height*0.95);
  if (n>0 & record) {
    if (!Ledon & v1[n-1]>=WD) {
      Ledon = true;
      myPort.write('H');
    }
    if (Ledon & v1[n-1]<WD) {
      Ledon = false;
      myPort.write('L');
    }
    if (!Ledon2 & v2[n-1]<SD) {
      Ledon2 = true;
      myPort.write('h');
    }
    if (Ledon2 & v2[n-1]>=SD) {
      Ledon2 = false;
      myPort.write('l');
    }
  } else {
    if (Ledon) {
      Ledon = false;
      myPort.write('L');
    }
    if (Ledon2) {
      Ledon2 = false;
      myPort.write('l');
    }
  }
}
void mousePressed() {
  if (mouseX>width*0.69 & mouseX<width*0.77 & mouseY>height*0.88 & mouseY<height*0.94)record=true;
  if (mouseX>width*0.815 & mouseX<width*0.9 & mouseY>height*0.88 & mouseY<height*0.94)record=false;
}
void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    int[] sensors = int(split(inString, ","));
    if (sensors.length >=2) {
      if (record) {
        v1[n]=sensors[1];
        v2[n]=sensors[0];
        println(n+" "+v1[n]+" "+v2[n]);
        n++;
        if (n>8) {
          n=0;
          v1 = new int[9];
          v2 = new int[9];
        }
      }
    }
  }
}