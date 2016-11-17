static final ArrayList<Character> firstRow = new ArrayList<Character>(Arrays.asList('q','w','e','r','t','y','u','i','o','p')); 
static final ArrayList<Character> secondRow = new ArrayList<Character>(Arrays.asList('a','s','d','f','g','h','j','k','l')); 
static final ArrayList<Character> thirdRow = new ArrayList<Character>(Arrays.asList('z','x','c','v','b','n','m')); 
//static Boolean outMode = false;

class Keyboard<Button extends KeyboardButton, ButtonFactory extends KeyboardButtonFactory<Button>> {
  boolean outMode = true;
  float maxWidth = 0;
  
  ArrayList<ArrayList<Button>> rows = new ArrayList<ArrayList<Button>>();
  ArrayList<ArrayList<Button>> smallRows = new ArrayList<ArrayList<Button>>();  
  ArrayList<KeyboardButton> topRow = new ArrayList<KeyboardButton>();
  KeyboardButton centerButton = null;
  KeyboardButton backButton = null;
  KeyboardButton spaceButton = null;
  private KeyboardButtonFactory<Button> Factory;
  
  //inits the charecters for a row - must be called in row order 
  void addRow(ArrayList<Character> A){
    float totalWidth = A.size() * (rectWidth + 2*keyMargin);
    maxWidth = Math.max(totalWidth - sizeOfInputArea, maxWidth);
    int row = rows.size();
    ArrayList<Button> newRow = new ArrayList<Button>();
    ArrayList<Button> newSmallRow = new ArrayList<Button>();
    Button prev = null;
    for(int i = 0; i < A.size(); i++){
      //make big char
      Character k = A.get(i);
      float centerXOffset = i*(2f*keyMargin + rectWidth) + keyMargin + rectWidth / 2f;
      float centerYoffset =  keyMargin + Factory.keyHeight() / 2f ;// + row*(2f*keyMargin + Factory.keyHeight());
      float centerX = inputAreaX + centerXOffset;
      float centerY = inputAreaY + centerYoffset;      
      Button newButton = Factory.factory(k, centerX, centerY, row, i, rectWidth, Factory.keyHeight(), null);
      
      //make small char
      centerXOffset = i*(2f*keyMargin + rectWidthSmall) + keyMargin + rectWidthSmall / 2f;
      centerYoffset = (sizeOfInputArea - rectHeightSmall * 3) + row*(2f*keyMargin + rectHeightSmall) + keyMargin + rectHeightSmall / 2f;
      centerX = inputAreaX + centerXOffset;// - (sizeOfInputArea - rectWidthSmall * 11)/2 ;
      centerY = inputAreaY + centerYoffset;      
      Button smallButton = Factory.factory(k, centerX, centerY, row, i, rectHeightSmall, rectWidthSmall, newButton);
      newSmallRow.add(smallButton);
      newButton.relButton = smallButton;
      newRow.add(newButton);
      if(prev != null){
        smallButton.leftButton = prev.relButton;
        prev.rightButton = newButton;
      }
      prev = smallButton;
    }
    rows.add(newRow);
    smallRows.add(newSmallRow);
  }
  
  Keyboard(ButtonFactory FC){
    Factory = FC; 
    topRow.add(null);
    topRow.add(null);
    topRow.add(null);
    addRow(firstRow);
    addRow(secondRow);
    addRow(thirdRow);
    float centerXOffset = keyMargin + sizeOfInputArea / 4f;
    float centerYoffset =  keyMargin + (Factory.keyHeight() * 3f / 4f) / 2f ;// + row*(2f*keyMargin + Factory.keyHeight());
    float centerX = inputAreaX + centerXOffset;
    float centerY = inputAreaY + centerYoffset;      
    spaceButton = Factory.factory(' ', centerX, centerY, 0, 0, (Factory.keyHeight() * 3f / 4f), sizeOfInputArea / 2f, null);
    backButton = Factory.factory('-', centerX + 2 * centerXOffset, centerY, 0, 0, (Factory.keyHeight() * 3f / 4f), sizeOfInputArea / 2f, null);
  }
  
  void drawTopRow(){
    if(K.outMode){
      spaceButton.drawButton(0);
      backButton.drawButton(0);
    } else {
      KeyboardButton centerButton = topRow.get(1);
      if(centerButton != null){
        for(KeyboardButton k: topRow){
          if(k != null){
            k.drawButton(centerButton.centerX - sizeOfInputArea - rectWidth / 5.5f);
          }
        }
      }
    }
  }
  //draws a keyboard at a given offset
  void drawKeyboard(float offsetX) {
    drawTopRow();
    //First draw all the buttons
    //if(outMode){
    for(ArrayList<Button> row: smallRows){
      for(KeyboardButton k: row){
        k.drawButton(0);
      }
    }
    //}
    //} else {
    //  for(ArrayList<Button> row: rows){
    //    for(KeyboardButton k: row){
    //      k.drawButton(offsetX);
    //    }
    //  }
    //}
    //second cover the sceen where you can't press them
    stroke(0);
    fill(0);
    //left
    //rect(0, 0, inputAreaX, height);
    //right
    //rect(inputAreaX + sizeOfInputArea, 0, width, height);
  }
  void zoomOut(){
    topRow.set(0, null);
    topRow.set(1, null);
    topRow.set(2, null);
    centerButton = null;
  }
  
  float zoomIn(PVector p) {
   for(ArrayList<Button> row: smallRows){
      for(KeyboardButton k: row){
        if(k.isWithinButton((int)p.x, (int)p.y)){
          if(k.relButton != null){
            outMode = false;
            return (float)(k.relButton.centerX - sizeOfInputArea);
          }
        }
      }
    }
    return 0;
  }
  
  float zoomInSplit(int x, int y){
    KeyboardButton b = whatButton(x, y);
    if(b == backButton || b == spaceButton){
      if(PrevKey != null){
        PrevKey.selected = false;
      }
      b.selected = true;
      PrevKey = b;
      drawTopRow();
    } else if(b != null){
      topRow.set(0, b.leftButton);
      topRow.set(1, b.relButton);
      topRow.set(2, b.rightButton);
      centerButton = topRow.get(1);
      outMode = false;
      drawTopRow();
      return (float)(b.relButton.centerX - sizeOfInputArea);
    }
    return 0;
  }

  KeyboardButton whatButton(int x, int y) {
    if(outMode){
      for(ArrayList<Button> row: smallRows){
        for(KeyboardButton k: row){
          if(k.isWithinButton(x, y)){
            if(k.relButton != null){
              return k;
            }
          }
        }
      }
      if(backButton.isWithinButton(x,y))
        return backButton;
      if(spaceButton.isWithinButton(x,y))
        return spaceButton;
    } else {
      KeyboardButton centerButton = topRow.get(1);
      if(centerButton != null){
        for(KeyboardButton k: topRow){
          if(k != null){
            if(k.isWithinButton(x + (int)centerButton.centerX  - sizeOfInputArea, y)){
              return k;
            }
          }
        }
      }
    }
    return null;
  }
}