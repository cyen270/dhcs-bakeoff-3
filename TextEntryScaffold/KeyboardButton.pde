interface KeyboardButtonFactory<Button extends KeyboardButton>{
  abstract float keyHeight();
  abstract Button factory(Character c, float x, float y, int r, int i);
}


abstract class KeyboardButton {
  Character key;
  String displayText;
  float centerX;
  float centerY;
  int row; //0-3
  int index;
  Boolean selected = false;
  
  KeyboardButton(Character c, float x, float y, int r, int i){
    index = i;
    key = c;
    displayText = c == ' ' ? "_" : Character.toString(Character.toUpperCase(key));
    centerX = x;
    centerY = y;
    row = r;
  }

  /*Tests if a point P is in the button
   */
  abstract Boolean isWithinButton(PVector p);
  
  /* Draws a button for a given offset
   */
  abstract void drawButton(float offsetX);
}


class RectKeyboardButton extends KeyboardButton {

  float x0;
  float y0;
  float x1;
  float y1;
  float cornerRadius = 7;
  
  RectKeyboardButton(Character c, float x, float y, int r, int i){
    super(c, x, y, r, i);
    //move center for row 
    centerX = x + r * rectWidth/2;
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
    if (((x0 + rectWidth - offsetX) > 0) || ((x0 - offsetX) > 0 &&  (x0 - offsetX) < width) ){
      //boarder black
      //fill white for temp
      if(selected){
        fill(0, 255, 0);
        stroke(0);
      } else{
        fill(255);
        stroke(0);
      }  
      strokeWeight(2.5);
      //draw rect
      rect(x0 - offsetX, y0, rectWidth, rectHeight, cornerRadius);
      
      //Draw text
      fill(0);
      textAlign(CENTER, CENTER);
      text(displayText, centerX - offsetX, centerY);

    }
  }

}

class RectKeyboardButtonFactory implements KeyboardButtonFactory<RectKeyboardButton>{
  float keyHeight(){
    return rectHeight;
  }
  RectKeyboardButton factory(Character c, float x, float y, int r, int i){
    return new RectKeyboardButton(c, x, y, r, i);
  }
}


class TriangleKeyboardButton extends KeyboardButton {
  
  PVector[] points = new PVector[3];
  float textX;
  float textY;

  TriangleKeyboardButton(char c, float x, float y, int r, int i){
    super(c, x, y, r, i);
    //todo: make points array from x, y, dir
    centerX += r == 2 ? rectWidth : 0;
    centerY += triangleHeight/2;
    index += r == 2 ? 1 : 0;
    float dir = r == 1 ? -1 : 1;
    dir *= index % 2 == 1 ? -1 : 1;
    textX = centerX - (dir*rectWidth / 2f) / 2f ;
    textY = centerY;
    points[0] = new PVector(centerX - dir*rectWidth / 2f , centerY - (triangleHeight) );
    points[1] = new PVector(centerX - dir*rectWidth / 2f, centerY + (triangleHeight) );
    points[2] = new PVector(centerX + dir*rectWidth / 2f, centerY);      
  }
  
  /*Tests if a point P is in the button
   */
  Boolean isWithinButton(PVector p){
    return false;
  }

  void drawButton(float offsetX){
    //boarder black
    stroke(0);
    //fill white for temp
    fill(255);
    //draw rect
    triangle(points[0].x - offsetX, points[0].y,
             points[1].x - offsetX, points[1].y,
             points[2].x - offsetX, points[2].y);
    //todo; Draw text
    fill(0);
    textAlign(CENTER, CENTER);
    text(this.key.toString(), textX - offsetX, textY);

  }

}
class TriangleKeyboardButtonFactory implements KeyboardButtonFactory<TriangleKeyboardButton>{
   float keyHeight(){
    return triangleHeight;
  }
  TriangleKeyboardButton factory(Character c, float x, float y, int r, int i){
    return new TriangleKeyboardButton(c, x, y, r, i);
  }
}