import java.util.Collections;
import java.util.Arrays;
import java.util.Collections;
//import android.util.Log;

String[] phrases; //contains all of the phrases
static int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
static int currTrialNum = 0; // the current trial number (indexes into trials array above)
static float startTime = 0; // time starts when the first letter is entered
static float finishTime = 0; // records the time of when the final trial ends
static float lastTime = 0; //the timestamp of when the last trial was completed
static float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
static float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
static float errorsTotal = 0; //a running total of the number of errors (when hitting next)
static String currentPhrase = ""; //the current target phrase
static String currentTyped = ""; //what the user has typed so far

//Device Settings 
//static final int DPIofYourDeviceScreen = 256; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
                                      //http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
static final int DPIofYourDeviceScreen = 218;
static final int sizeOfInputArea = DPIofYourDeviceScreen*1 ; //aka, 1.0 inches square!

static Boolean started = false; 

//keyboard constants (needed for declarations here)
static final float keyMargin = 0;
static final float rectWidthSmall = (sizeOfInputArea - keyMargin * 4f) / 10f;
static final float rectHeightSmall = ((sizeOfInputArea - keyMargin * 6f) / 3f) * 2f / 3f;

static final int rectWidth = (int)((sizeOfInputArea - keyMargin * 4f) / 3.5f);
    //might change height to accmodate for pull downs
static final float rectHeight = ((sizeOfInputArea - keyMargin * 6) / 3f);
static final float triangleHeight = (sizeOfInputArea / 2f - keyMargin * 2) / 2f  ;
static Keyboard K;

//gloabls
//    screen state
static PFont defaultFont = null; 
static int inputAreaX = 0;
static int inputAreaY = 0;
//   keyboard state
static float currentOffset = 0;
static KeyboardButton PrevKey = null;
static KeyboardButton CurrentKey = null;
//   scroll state
static float currentScroll = 0;
static int mouseDownX = 0;
static float mouseDownMilis = 0;
static float velocity = 0;
static float lastAutoMove = 0;

//Strings
static String phraseCountString =  "Phrase " + (currTrialNum+1) + " of " + totalTrialNum;;
static String targetString = "Target:     " + currentPhrase;;
static String enteredStringNoCursor =  "Entered:   " + currentTyped;
static String enteredStringCursor = "Entered:   " + currentTyped + "|";
String currentWord = "";


//Implementation settings 
//  cursor speed
static final int blinkingSpeed = 400; //number of milis betwen blinks
//    scroll
static final float scrollLimit = rectWidth / 2;
static float deceleration = 1 / 1000f;

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  defaultFont = createFont("Arial", 24);
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  //size(540, 960); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  size(480, 854);
  textFont(defaultFont); //set the font to arial 24
  textLeading(26);
  rectMode(CORNER);
  inputAreaX = (int)(width/2f - sizeOfInputArea/2f);
  inputAreaY = (int)(height/2f - sizeOfInputArea/2f);

  noStroke(); //my code doesn't use any strokes.
  K = new Keyboard<RectKeyboardButton, RectKeyboardButtonFactory>(new RectKeyboardButtonFactory());
  //K = new Keyboard<TriangleKeyboardButton, TriangleKeyboardButtonFactory>(new TriangleKeyboardButtonFactory());
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(0); //clear background

 // image(watch,-200,200);
  if (finishTime!=0)
  {
    fill(255);
    textAlign(LEFT);
    //text("Finished", 280, 150);
    text("Trials complete!", 0, 40); //output
    text("Total time taken: " + (finishTime - startTime), 0, 80); //output
    text("Total letters entered: " + lettersEnteredTotal,0, 120); //output
    text("Total letters expected: " + lettersExpectedTotal, 0, 160); //output
    text("Total errors entered: " + errorsTotal, 0, 200); //output
    
    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    text("Raw WPM: " + wpm, 0, 240); //output
    
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    
    text("Freebie errors: " + freebieErrors, 0, 280); //output
    float penalty = max(errorsTotal-freebieErrors,0) * .5f;
    
    text("Penalty: " + penalty, 0, 320);
    text("WPM w/ penalty: " + (wpm-penalty), 0, 360); //yes, minus, becuase higher WPM is better

    return;
  }
  
  fill(100);
  rect(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  //if (startTime==0 & started)
  //{
  //  nextTrial(); //start the trials!
  //}

  if (startTime!=0)
  {
    K.drawKeyboard(currentOffset);
        
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text(phraseCountString, 70, 50); //draw the trial count
    fill(255);
    text(targetString, 0, 100, width-5, 130); //draw the target string
    if((millis() / blinkingSpeed) % 2 == 0 ){
      text(enteredStringNoCursor, 0, 160, width-5, 180); //draw what the user has entered thus far 
    } else {
      text(enteredStringCursor, 0, 160, width-5, 180); //draw what the user has entered thus far 
    }
    
    
    fill(255, 0, 0);
    rect(width-200, height-200, 200, 200); //drag next button
    fill(255);
    text("NEXT > ", width-150, height-100); //draw next label

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

void addLetter(char c){
  if(c == '←'){
    int len = currentTyped.length();
    if(len > 0){
      currentTyped = currentTyped.substring(0, len - 1);
    }
  } else {
    currentTyped =  currentTyped + c;
    currentWord += c;
  }
  if(c == ' '){
    currentWord = "";
  }
  enteredStringNoCursor = "Entered:   " + currentTyped;
  enteredStringCursor = "Entered:   " + currentTyped + "|";
}

void mouseDragged(){
  if(!K.outMode){
    if(didMouseClick(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea)){
      KeyboardButton b = K.whatButton((int)(mouseX + currentOffset), mouseY);
      if(b != null){
        if(PrevKey != b){
          if(PrevKey != null){
            PrevKey.selected = false;
          }
          b.selected = true;
          PrevKey = b;
          b.drawButton(currentOffset);
          //K.drawTopRow();
        }
      } else {
        if(PrevKey != null){
           PrevKey.selected = false;
           PrevKey.drawButton(currentOffset);
           PrevKey = null;
           //K.drawTopRow();
        }
      }
    }
  }
}

//void startAutoScroll(){ 
//  //don't double start
//  if(velocity == 0 && currentScroll > scrollLimit){
//    lastAutoMove = millis();
//    float t = millis() - mouseDownMilis;
//    float dx = mouseDownX - mouseX;
//    velocity = dx / t;
//    if(velocity > 3){
//      velocity = 3;
//    } else if (velocity < -3){
//      velocity = -3;
//    }
//    println("Velocity = " + velocity);
//  }
//}

boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

void mouseReleased(){
  if(startTime==0 || !started){
    started = true;
    nextTrial();
    return;
  } else if(didMouseClick(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea)){
    KeyboardButton b = K.whatButton((int)(mouseX + currentOffset), mouseY);
    if(b != null){
      addLetter(b.key);
    }
    K.zoomOut();
  }
  if(PrevKey != null){
    PrevKey.selected = false;
    PrevKey = null;
  }
  /*
  if(didMouseClick(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea)){
    PVector virtualPoint = new PVector(mouseX + currentOffset, mouseY);
    if(K.outMode && CurrentKey != null){
      float newOffset = K.zoomIn(virtualPoint);
      currentOffset = newOffset;
    } else {
      if(CurrentKey != null && currentScroll < scrollLimit){
        currentTyped += CurrentKey.key;
        CurrentKey.selected = false;
        CurrentKey = null;
        PrevKey = null;
        K.outMode = true;
        currentOffset = 10;
      }
    }
    startAutoScroll();
  }
  */
  K.outMode = true;
}

void mousePressed()
{
  if(startTime==0)
    return;
  if(didMouseClick(inputAreaX, inputAreaY, sizeOfInputArea, sizeOfInputArea)){
    //KeyboardButton Key = K.whatButton(mouseX, mouseY);
    //float newOffset = K.zoomInSplit(mouseX, mouseY);
    currentOffset  = K.zoomIn(mouseX, mouseY);
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
  if (startTime!=0 && currTrialNum == totalTrialNum-1) //check to see if experiment just finished
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
  //Log.d("", "next trial");
  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc donflnsdlfk sd sidflksd f sdlf hdsf "; // uncomment this to override the test phrase (useful for debugging)
  phraseCountString = "Phrase " + (currTrialNum+1) + " of " + totalTrialNum;
  targetString = "Target:     " + currentPhrase;
  enteredStringNoCursor = "Entered:   " + currentTyped;
  enteredStringCursor = "Entered:   " + currentTyped + "|";  
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