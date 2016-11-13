
float keyMargin = 0;
float rectWidth = (sizeOfInputArea - keyMargin * 4) / 2.5;
    //might change height to accmodate for pull downs
float rectHeight = (sizeOfInputArea - keyMargin * 6) / 3;
float triangleHeight = (sizeOfInputArea / 2f - keyMargin * 2) / 2f  ;

enum KEY {
  A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, DEL, SPACE, NONE
}

class Keyboard<Button extends KeyboardButton, ButtonFactory extends KeyboardButtonFactory<Button>> {
  float maxWidth = 0;
  
  ArrayList<ArrayList<Button>> rows = new ArrayList<ArrayList<Button>>();
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
    for(int i = 0; i < A.size(); i++){
      Character k = A.get(i);
      float centerXOffset = i*(2f*keyMargin + rectWidth) + keyMargin + rectWidth / 2f;
      println("keyheight =" + Factory.keyHeight());
      float centerYoffset = row*(2f*keyMargin + Factory.keyHeight()) + keyMargin + Factory.keyHeight() / 2f;
      float centerX = inputAreaX + centerXOffset;
      float centerY = inputAreaY + centerYoffset;      
      Button newButton = Factory.factory(k, centerX, centerY, row, i);
      newRow.add(newButton);
    }
    rows.add(newRow);
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
    for(int r = 0; r < rows.size(); r++){
      ArrayList<Button> row = rows.get(r);
      for(int j = 0; j < row.size(); j++){
        KeyboardButton k = row.get(j);
        k.drawButton(offsetX);
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

  KeyboardButton whatButton(PVector p) {
    for(int r = 0; r < rows.size(); r++){
      ArrayList<Button> row = rows.get(r);
      for(int j = 0; j < row.size(); j++){
        KeyboardButton k = row.get(j);
        if(k.isWithinButton(p)){
          return k;
        }
      }
    }
    return null;
  }
}