import java.util.Collections;
import java.util.Arrays;
import java.util.Collections;

String[] phrases; //contains all of the phrases
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
static final int DPIofYourDeviceScreen = 240; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
                                      //http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
static final float sizeOfInputArea = DPIofYourDeviceScreen*1 ; //aka, 1.0 inches square!

//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';

static final int blinkingSpeed = 500; //number of milis betwen blinks

static Keyboard K;
float currentOffset = 0;
float inputAreaX;
float inputAreaY;
float currentScroll = 0;
float scrollLimit = rectWidth / 2;
KeyboardButton PrevKey = null;
KeyboardButton CurrentKey = null;

float mouseDownX = 0;
float mouseDownMilis = 0;
float velocity = 0;
float lastAutoMove = 0;
float deceleration = 1 / 1000f;

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
    
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(480, 854); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24
  rectMode(CORNER);
  inputAreaX = width/2 - sizeOfInputArea/2;
  inputAreaY = height/2 - sizeOfInputArea/2;

  noStroke(); //my code doesn't use any strokes.
  K = new Keyboard<RectKeyboardButton, RectKeyboardButtonFactory>(new RectKeyboardButtonFactory());
  //K = new Keyboard<TriangleKeyboardButton, TriangleKeyboardButtonFactory>(new TriangleKeyboardButtonFactory());
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(0); //clear background

 // image(watch,-200,200);
  fill(100);
  rect(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"
  if(velocity != 0 && lastAutoMove != 0){
    float sign = velocity < 0 ? -1f : 1f; 
    float newVelocity = sign * (Math.abs(velocity) - deceleration * (millis() - lastAutoMove));
    if(Math.abs(newVelocity) >= Math.abs(velocity)){
      velocity = 0;
    } else {
      velocity = newVelocity;
    }
    velocity = Math.abs(velocity) < 0.05 ? 0 : velocity;
    velocity = Math.abs(velocity) > 10 ? 10 : velocity;
    float dx = velocity * (millis() - lastAutoMove);
    if(sign == -1 && (currentOffset + dx) <= 0){
      velocity = 0;
    } if(sign == 1 && (currentOffset + dx) >= K.maxWidth){
      velocity = 0;
    }
    println("new velocity = " + velocity);
    scroll(dx);
  }
  if (finishTime!=0)
  {
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    K.drawKeyboard(currentOffset);
        
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 0, 100); //draw the target string
    if((millis() / blinkingSpeed) % 2 == 0 ){
      text("Entered:  " + currentTyped, 0, 140); //draw what the user has entered thus far 
    } else {
      text("Entered:  " + currentTyped + "|", 0, 140); //draw what the user has entered thus far 
    }
    
    
    fill(255, 0, 0);
    rect(width-200, height-200, 200, 200); //drag next button
    fill(255);
    text("NEXT > ", width-100, height-100); //draw next label

    //my draw code
    //textAlign(CENTER);
    //text("" + currentLetter, 200+sizeOfInputArea/2, 200+sizeOfInputArea/3); //draw current letter
    //fill(255, 0, 0);
    //rect(200, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw left red button
    //fill(0, 255, 0);
    //rect(200+sizeOfInputArea/2, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw right green button
  }
  
}

void scroll(float dx){
   currentOffset += dx;
   currentOffset = currentOffset < 0 ? 0 : currentOffset;
   currentOffset = currentOffset > K.maxWidth ? K.maxWidth : currentOffset;
   currentScroll += Math.abs(dx);
   if(currentScroll > scrollLimit && CurrentKey != null){
     CurrentKey.selected = false;
     CurrentKey = null;
   }
}

void mouseDragged(){
   if(didMouseClick(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea)){
     scroll(pmouseX - mouseX);
   } else {
     startAutoScroll();
   }
}

void startAutoScroll(){ 
  //don't double start
  if(velocity == 0 && currentScroll > scrollLimit){
    lastAutoMove = millis();
    float t = millis() - mouseDownMilis;
    float dx = mouseDownX - mouseX;
    velocity = dx / t;
    if(velocity > 3){
      velocity = 3;
    } else if (velocity < -3){
      velocity = -3;
    }
    println("Velocity = " + velocity);
  }
}

boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

void mouseReleased(){
  if(startTime==0)
    return;
  if(didMouseClick(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea)){
    PVector virtualPoint = new PVector(mouseX + currentOffset, mouseY);
    if(K.smallMode && CurrentKey != null){
      float newOffset = K.zoomIn(virtualPoint);
      currentOffset = newOffset;
    } else {
      if(CurrentKey != null && currentScroll < scrollLimit){
        currentTyped += CurrentKey.key;
        CurrentKey.selected = false;
        CurrentKey = null;
        PrevKey = null;
        //K.smallMode = true;
        //currentOffset = 0;
      }
    }
    //if(CurrentKey == PrevKey && CurrentKey != null){
    //  currentTyped += CurrentKey.key;
    //  CurrentKey.selected = false;
    //  CurrentKey = null;
    //  PrevKey = null;
    //}
    startAutoScroll();
    //if(currentScroll > scrollLimit){
    //  lastAutoMove = millis();
    //  float t = millis() - mouseDownMilis;
    //  float dx = mouseDownX - mouseX;
    //  velocity = dx / t;
    //  if(velocity > 3){
    //    velocity = 3;
    //  } else if (velocity < -3){
    //    velocity = -3;
    //  }
    //  println("Velocity = " + velocity);
    //}
  }

}

void mousePressed()
{
  if(startTime==0)
    return;
  if(didMouseClick(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea)){
    PVector virtualPoint = new PVector(mouseX + currentOffset, mouseY);
    if(velocity < 0.06){
      mouseDownMilis = millis();
      mouseDownX = mouseX;
      KeyboardButton NextKey = K.whatButton(virtualPoint);
      if(CurrentKey != null){
        CurrentKey.selected = false;
      }
      if(NextKey != null){
        NextKey.selected = true;
      }
      PrevKey = CurrentKey;
      CurrentKey = NextKey;
      currentScroll = 0;
    } else {
      velocity = 0;
    }
  }

  //PVector virtualPoint = new PVector(mouseX + currentOffset, mouseY);
  //PrevKey = K.whatButton(virtualPoint);
  
  /*
  if (didMouseClick(200, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in left button
  {
    currentLetter --;
    if (currentLetter<'_') //wrap around to z
      currentLetter = 'z';
  }

  if (didMouseClick(200+sizeOfInputArea/2, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in right button
  {
    currentLetter ++;
    if (currentLetter>'z') //wrap back to space (aka underscore)
      currentLetter = '_';
  }

  if (didMouseClick(200, 200, sizeOfInputArea, sizeOfInputArea/2)) //check if click occured in letter area
  {
    if (currentLetter=='_') //if underscore, consider that a space bar
      currentTyped+=" ";
    else if (currentLetter=='`' & currentTyped.length()>0) //if `, treat that as a delete command
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    else if (currentLetter!='`') //if not any of the above cases, add the current letter to the typed string
      currentTyped+=currentLetter;
  }
*/
  //You are allowed to have a next button outside the 2" area
  if (didMouseClick(width-200, height-200, 200, 200)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
  }
  
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

    if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output
    
    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    System.out.println("Raw WPM: " + wpm); //output
    
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    
    System.out.println("Freebie errors: " + freebieErrors); //output
    float penalty = max(errorsTotal-freebieErrors,0) * .5f;
    
    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    System.out.println("==================");
    
    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  }
  else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}

//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}