#include <MeAuriga.h>

MeUltrasonicSensor ultraSensor(PORT_10);

int distance;

#define ALLLEDS 0

#define LEDNUM 12

#define BATTMAX 613 // 7.2v/12v * 1023

int battLevel = 0;

MeRGBLed led(0, LEDNUM);

int turnWait = 1100;

MeBuzzer buzzer;

MeLineFollower lineFollower(PORT_9);
MeEncoderOnBoard encoderRight(SLOT1);
MeEncoderOnBoard encoderLeft(SLOT2);

int baseMoveSpeed = 90;

int distanceLimit = 50;

int moveSpeed = baseMoveSpeed;

enum lastAction{FORWARD, LEFT, RIGHT, T};

enum steps{START, FIND_OBJECT, LEFT_RIGHT, WIN};

lastAction lastAction;

steps steps;


unsigned long currentTime = 0;

bool detectLine = true;

unsigned long serialPrevious = 0;
int serialInterval = 500;
String msg = "";

void isr_process_encoder1(void)
{
  if(digitalRead(encoderRight.getPortB()) == 0)
  {
    encoderRight.pulsePosMinus();
  }
  else
  {
    encoderRight.pulsePosPlus();;
  }
}

void isr_process_encoder2(void)
{
  if(digitalRead(encoderLeft.getPortB()) == 0)
  {
    encoderLeft.pulsePosMinus();
  }
  else
  {
    encoderLeft.pulsePosPlus();
  }
}

void setup()
{
  attachInterrupt(encoderRight.getIntNum(), isr_process_encoder1, RISING);
  attachInterrupt(encoderLeft.getIntNum(), isr_process_encoder2, RISING);
  Serial.begin(115200);
  
  //Set PWM 8KHz
  TCCR1A = _BV(WGM10);
  TCCR1B = _BV(CS11) | _BV(WGM12);

  TCCR2A = _BV(WGM21) | _BV(WGM20);
  TCCR2B = _BV(CS21);

  encoderRight.setPulse(9);
  encoderLeft.setPulse(9);
  encoderRight.setRatio(39.267);
  encoderLeft.setRatio(39.267);
  encoderRight.setPosPid(1.8,0,1.2);
  encoderLeft.setPosPid(1.8,0,1.2);
  encoderRight.setSpeedPid(0.18,0,0);
  encoderLeft.setSpeedPid(0.18,0,0);

  led.setpin(44);

  if (!led.setColor(0, 0, 0))
    Serial.println("Erreur LED");
    
  led.show();

  steps = START;
   buzzer.setpin(45);
}

float g = 783.9;
float a = 880;
float c = 1046.50;
float e = 1318.51;
float b = 987.77;
float d = 1174.66;
float f = 1396.91;

byte lines;

bool doColor = true;

void loop() {
  lines = lineFollower.readSensors();
  switch(steps){
    case START:
      reachLineStart();
      break;
    case FIND_OBJECT:
      findObject();
      break;
    case LEFT_RIGHT:
      CheckLeftRight();
      break;
    case WIN:
      win();
      break;
  }
  
  if (detectLine && (!distance > distanceLimit || !lines != S1_OUT_S2_OUT))
  switch (lines) {
    case S1_IN_S2_IN:
      lastAction = FORWARD;
      Forward();
      break;
    case S1_IN_S2_OUT:
      lastAction = LEFT;
      TurnLeft();
      break;
    case S1_OUT_S2_IN:
      lastAction = RIGHT;
      TurnRight();
      break;
    case S1_OUT_S2_OUT:
      Lost();
      break;
  }
  currentTime = millis();

  if(doColor)color();
}

float j, k;

void colorWin(){
    for (uint8_t t = 0; t < LEDNUM; t++ )
  {
    uint8_t red  = 8 * (1 + sin(t / 2.0 + j / 4.0) );
    uint8_t green = 8 * (1 + sin(t / 1.0 + f / 9.0 + 2.1) );
    uint8_t blue = 8 * (1 + sin(t / 3.0 + k / 14.0 + 4.2) );
    led.setColorAt( t, red, green, blue );
  }
  led.show();

  j += random(1, 6) / 6.0;
  f += random(1, 6) / 6.0;
  k += random(1, 6) / 6.0;
}

bool boolTurnLeft = true;

long lastTurn = 0;

void CheckLeftRight()
{
  if (lines != S1_OUT_S2_OUT || distance > distanceLimit)return;
  lastTurn = millis();
  moveSpeed = baseMoveSpeed / 2;
    while (millis() - lastTurn <= turnWait / 2)
    {
      TurnLeft();
      color();
    }
    moveSpeed = baseMoveSpeed;
    if (ultraSensor.distanceCm() > distanceLimit) return;
    moveSpeed = baseMoveSpeed / 2;
    lastTurn = millis();
    while (millis() - lastTurn <= turnWait)
    {
      TurnRight();
      color();
    }
    moveSpeed = baseMoveSpeed;
    if (ultraSensor.distanceCm() > distanceLimit) return;
    moveSpeed = baseMoveSpeed / 2;
    lastTurn = millis();
    while (millis() - lastTurn <= turnWait / 2)
    {
      TurnLeft();
      color();
    }
    lastTurn = millis();
    while (millis() - lastTurn <= turnWait / 2)
    {
      stop();
      color();
    }
    lastTurn = millis();
    while (millis() - lastTurn <= turnWait)
    {
      TurnRight();
      color();
    }
    stop();
    detectLine = false;
    steps = WIN;
    doColor = false;
}

void win(){
  colorWin();
}

int objectDistance = 0;

void findObject(){
  if (distance > 30 || lines != S1_OUT_S2_OUT)return;
  objectDistance = ultraSensor.distanceCm();
  detectLine = false;
  moveSpeed = baseMoveSpeed / 2;
  while (ultraSensor.distanceCm() > 10){
    color();
    Forward();
  }
  colorObject();
  while (lineFollower.readSensors() == S1_OUT_S2_OUT || ultraSensor.distanceCm() < objectDistance){
    color();
    Backward();
  }
  lastTurn = millis();
  while (millis() - lastTurn <= turnWait / 1.5){
    TurnLeft();
    color();
  }
  moveSpeed = baseMoveSpeed;
   detectLine = true;
  steps = LEFT_RIGHT;
}

uint8_t red = 0, green = 0,blue = 0;

void colorObject()
{
  red = 0;
  green = 0;
  blue = 200;
  for (uint8_t t = 6; t < LEDNUM; t++) {
  led.setColorAt(t, red, green, blue);
  }
  led.show();
}

int lastColor = 0;

void color()
{   
     distance = ultraSensor.distanceCm();
    if (distance <= 30) {
      if (lastColor <= 30) return;
      red = 200;
      green = 0;
      blue = 0;
    } else if (distance <= 60) {
      if (lastColor <= 60) return;
      red = 200;
      green = 75;
      blue = 0;
    
    } else {
      if (lastColor >= 60) return;
      red = 0;
      green = 200;
      blue = 0;
    }
    lastColor = distance;
    for (uint8_t t = 0; t < 6; t++) {
    led.setColorAt(t, red, green, blue);
    }
    led.show();


}

void reachLineStart()
{
  while (lineFollower.readSensors() == S1_OUT_S2_OUT)
  {
    Forward();
    color();
  }
  moveSpeed = baseMoveSpeed / 2;
  while (ultraSensor.distanceCm() <= distanceLimit){
    TurnRight();
    color();
  }
  moveSpeed = baseMoveSpeed;
  detectLine = true;
  steps = FIND_OBJECT;
}


void stop(){
  encoderLeft.setMotorPwm(0);  
  encoderRight.setMotorPwm(0);  
}

void Forward() {
  encoderLeft.setMotorPwm(moveSpeed);  
  encoderRight.setMotorPwm(-moveSpeed);  
}

void TurnLeft() {
  encoderLeft.setMotorPwm(-moveSpeed * 2);  
  encoderRight.setMotorPwm(-moveSpeed * 2);
}

void TurnRight() {
  encoderLeft.setMotorPwm(moveSpeed * 2);  
  encoderRight.setMotorPwm(moveSpeed * 2); 
}

void Lost() {

  if (distance <= 30)
  {
     lastAction = T;
  }
  switch (lastAction)
  {
    case FORWARD:
      TurnRight();
      break;
    case LEFT:
      TurnLeft();
      break;
    case RIGHT:
      TurnRight();
      break;
    case T:
      CheckLeftRight();
      break;
    default:
      TurnRight();
      break;
  }
}

void Backward() {
  encoderLeft.setMotorPwm(-moveSpeed);  
  encoderRight.setMotorPwm(moveSpeed);  
}

void encoderRight_interrupt(void)
{
  if(digitalRead(encoderRight.getPortB()) == 0)
  {
    encoderRight.pulsePosMinus();
  }
  else
  {
    encoderRight.pulsePosPlus();;
  }
}

void encoderLeft_interrupt(void)
{
  if(digitalRead(encoderLeft.getPortB()) == 0)
  {
    encoderLeft.pulsePosMinus();
  }
  else
  {
    encoderLeft.pulsePosPlus();
  }
}

// Configuration des encodeurs
void encoderSetup() {
  attachInterrupt(encoderRight.getIntNum(), encoderRight_interrupt, RISING);
  attachInterrupt(encoderLeft.getIntNum(), encoderLeft_interrupt, RISING);
  
  //Set PWM 8KHz
  TCCR1A = _BV(WGM10);
  TCCR1B = _BV(CS11) | _BV(WGM12);

  TCCR2A = _BV(WGM21) | _BV(WGM20);
  TCCR2B = _BV(CS21);
  
  encoderRight.setPosPid(1.8,0,1.2);
  encoderLeft.setPosPid(1.8,0,1.2);
  encoderRight.setSpeedPid(0.18,0,0);
  encoderLeft.setSpeedPid(0.18,0,0);
}

int getBattLevel() {
  int value = analogRead(A4);
  return (int)((value * 100.0) / BATTMAX);
}


void serialPrintTask() {
  if (currentTime - serialPrevious < serialInterval) return;

  serialPrevious = currentTime;

  if (msg != "") {
    Serial.print("Batt : ");
    Serial.print(getBattLevel());
    Serial.print("\t");
    Serial.print(msg);
    Serial.println("");
    msg = "";
  }

}
