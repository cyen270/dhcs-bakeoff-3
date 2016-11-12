
interface KeyboardButton {
  
  /*Tests if a point P is in the button
   */
  Boolean isWithinButton(PVector p);
  
  /* Draws a button for a given offset
   */
  void drawButton(float offsetX);

}

class RectKeyboardButton implements KeyboardButton{
  Character key;
  float centerX;
  float centerY;
  int row; //0-3
  PVector[] points; 

  float x0;
  float y0;
  float x1;
  float y1;
  float cornerRadius = 7;
  
  RectKeyboardButton(Character c, float x, float y, int r){
    //todo: make points array from x, y, dir
    key = c;
    centerX = x + r * rectWidth/2;
    centerY = y;
    row = r;
    x0 = centerX - rectWidth/2;
    x1 = centerX + rectWidth/2;
    y0 = centerY - rectHeight/2;
    y1 = centerY + rectHeight/2;
}
  
  /*Tests if a point P is in the button
   */
  Boolean isWithinButton(PVector p){
    return (p.x >= x0) && ((p.x - x0) <= rectWidth) &&
           (p.y >= y0) && ((p.y - y0) <= rectHeight);
  }

  void drawButton(float offsetX){
    //boarder black
    stroke(0);
    //fill red for temp
    fill(255, 0, 0);
    //draw rect
    rect(x0 - offsetX, y0, rectWidth, rectHeight, cornerRadius);
    //todo; Draw text
    fill(0);
    textAlign(CENTER, CENTER);
    text(this.key.toString(), centerX - offsetX, centerY);
  }

}

//class TriangleKeyboardButton implements KeyboardButton{
  
//  TriangleKeyboardButton(char c, float x, float y, int r){
//    //todo: make points array from x, y, dir
//    key = c;
//    centerX = x;
//    centerY = y;
//    row = r;
//  }
  
//  /*Tests if a point P is in the button
//   */
//  Boolean isWithinButton(PVector p){
//    return false;
//  }

//  void drawButton(float offsetX){
//    triangle(points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
//  }

//}