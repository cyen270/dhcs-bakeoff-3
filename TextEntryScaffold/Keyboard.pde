
static float keyMargin = 0;
static float rectWidthSmall = (sizeOfInputArea - keyMargin * 4) / 11;
static float rectHeightSmall = (sizeOfInputArea - keyMargin * 6) / 12;

static float rectWidth = (sizeOfInputArea - keyMargin * 4) / 3.5;
    //might change height to accmodate for pull downs
static float rectHeight = (sizeOfInputArea - keyMargin * 6) / 3;
static float triangleHeight = (sizeOfInputArea / 2f - keyMargin * 2) / 2f  ;

class Keyboard<Button extends KeyboardButton, ButtonFactory extends KeyboardButtonFactory<Button>> {
  boolean smallMode = false;//true;
  float maxWidth = 0;
  
  ArrayList<ArrayList<Button>> rows = new ArrayList<ArrayList<Button>>();
  ArrayList<ArrayList<Button>> smallRows = new ArrayList<ArrayList<Button>>();  
  ArrayList<Character> firstRow = new ArrayList<Character>(Arrays.asList('q','w','e','r','t','y','u','i','o','p')); 
  ArrayList<Character> secondRow = new ArrayList<Character>(Arrays.asList('a','s','d','f','g','h','j','k','l')); 
  ArrayList<Character> thirdRow = new ArrayList<Character>(Arrays.asList('z','x','c','v','b','n','m', ' ')); 
  //Class<? extends KeyboardButton> KeyboardButtonType = RectKeyboardButton.class();

  KeyboardButton[] buttons;
  private KeyboardButtonFactory<Button> Factory;
  
  //inits the charecters for a row - must be called in row order 
  void addRow(ArrayList<Character> A){
    float totalWidth = A.size() * (rectWidth + 2*keyMargin);
    maxWidth = Math.max(totalWidth - sizeOfInputArea, maxWidth);
    int row = rows.size();
    ArrayList<Button> newRow = new ArrayList<Button>();
    ArrayList<Button> newSmallRow = new ArrayList<Button>();
    for(int i = 0; i < A.size(); i++){
      //make big char
      Character k = A.get(i);
      float centerXOffset = i*(2f*keyMargin + rectWidth) + keyMargin + rectWidth / 2f;
      println("keyheight =" + Factory.keyHeight());
      float centerYoffset = row*(2f*keyMargin + Factory.keyHeight()) + keyMargin + Factory.keyHeight() / 2f;
      float centerX = inputAreaX + centerXOffset;
      float centerY = inputAreaY + centerYoffset;      
      Button newButton = Factory.factory(k, centerX, centerY, row, i);
      newRow.add(newButton);
      
      //make small char
      centerXOffset = i*(2f*keyMargin + rectWidthSmall) + keyMargin + rectWidthSmall / 2f;
      println("keyheight =" + rectHeightSmall);
      centerYoffset = sizeOfInputArea /2 + row*(2f*keyMargin + rectHeightSmall) + keyMargin + rectHeightSmall / 2f;
      centerX = inputAreaX + centerXOffset;
      centerY = inputAreaY + centerYoffset;      
      Button smallButton = Factory.factory(k, centerX, centerY, row, i, rectHeightSmall, rectWidthSmall, newButton);
      newSmallRow.add(smallButton);
    }
    rows.add(newRow);
    smallRows.add(newSmallRow);
  }
  
  Keyboard(ButtonFactory FC){
    Factory = FC;    
    addRow(firstRow);
    addRow(secondRow);
    addRow(thirdRow);
  }
  
  //draws a keyboard at a given offset
  void drawKeyboard(float offsetX) {
    //First draw all the buttons
    if(smallMode){
      for(ArrayList<Button> row: smallRows){
        for(KeyboardButton k: row){
          k.drawButton(offsetX);
        }
      }
    } else {
      for(ArrayList<Button> row: rows){
        for(KeyboardButton k: row){
          k.drawButton(offsetX);
        }
      }
    }
    //second cover the sceen where you can't press them
    stroke(0);
    fill(0);
    //left
    rect(0, 0, inputAreaX, height);
    //right
    rect(inputAreaX + sizeOfInputArea, 0, width, height);
  }
  float zoomIn(PVector p) {
   for(ArrayList<Button> row: smallRows){
      for(KeyboardButton k: row){
        if(k.isWithinButton(p)){
          if(k.bigButton != null){
            smallMode = false;
            return (float)(k.bigButton.centerX - sizeOfInputArea / 2f);
          }
        }
      }
    }
    return 0;
  }
  KeyboardButton whatButton(PVector p) {
    if(smallMode){
       for(ArrayList<Button> row: smallRows){
        for(KeyboardButton k: row){
          if(k.isWithinButton(p)){
            if(k.bigButton != null){
              return k;
            }
          }
        }
      }
    } else {
      for(ArrayList<Button> row: rows){
        for(KeyboardButton k: row){
          if(k.isWithinButton(p)){
            return k;
          }
        }
      }
    }
    return null;
  }
}