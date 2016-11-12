
float keyMargin = 10;
float rectWidth = (sizeOfInputArea - keyMargin * 4) / 2;
    //might change height to accmodate for pull downs
float rectHeight = (sizeOfInputArea - keyMargin * 6) / 3;


enum KEY {
  A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, DEL, SPACE, NONE
}

class Keyboard {
  
  ArrayList<ArrayList<KeyboardButton>> rows = new ArrayList<ArrayList<KeyboardButton>>();
  ArrayList<Character> firstRow = new ArrayList<Character>(Arrays.asList('q','w','e','r','t','y','u','i','o','p')); 
  ArrayList<Character> secondRow = new ArrayList<Character>(Arrays.asList('a','s','d','f','g','h','j','k','l')); 
  ArrayList<Character> thirdRow = new ArrayList<Character>(Arrays.asList('z','x','c','v','b','n','m')); 
  //Class<? extends KeyboardButton> KeyboardButtonType = RectKeyboardButton.class();

  KeyboardButton[] buttons;
  
  //inits the charecters for a row - must be called in row order 
  void addRow(ArrayList<Character> A){
    int row = rows.size();
    ArrayList<KeyboardButton> newRow = new ArrayList<KeyboardButton>();
    for(int i = 0; i < A.size(); i++){
      Character k = A.get(i);
      float centerXOffset = i*(2f*keyMargin + rectWidth) + keyMargin + rectWidth / 2f;
      float centerYoffset = row*(2f*keyMargin + rectHeight) + keyMargin + rectHeight / 2f;
      float centerX = inputAreaX + centerXOffset;
      float centerY = inputAreaY + centerYoffset;      
      KeyboardButton newButton = new RectKeyboardButton(k, centerX, centerY, row);
      newRow.add(newButton);
    }
    rows.add(newRow);
  }
  
  Keyboard(){
    addRow(firstRow);
    addRow(secondRow);
    addRow(thirdRow);
  }
  
  //draws a keyboard at a given offset
  void drawKeyboard(float offsetX) {
    //First draw all the buttons
    for(int r = 0; r < rows.size(); r++){
      ArrayList<KeyboardButton> row = rows.get(r);
      for(int j = 0; j < row.size(); j++){
        KeyboardButton k = row.get(j);
        k.drawButton(offsetX);
      }
    }
    //second cover the sceen where you can't press them
    fill(0);
    //left
    rect(0, 0, inputAreaX, height);
    //right
    rect(inputAreaX + sizeOfInputArea, 0, width, height);
  }

  KeyboardButton whatButton() {
    return null;
  }
}