//// Regular Cellular Automaton, but keeps a record of all values so that you may scroll up or down through all the values.

//SCROLL
float y = 0;
float pageLength = 0;
float pageEnd = 0;
float scrollLength = 0;
float scrollStart = 0;
float scrollEnd;
float scrollWidth = 4;
boolean scrolling = false;
//--------------

int repeats = 50;     // This number is used to determines how many rows are to be produced by multiplying this number with the number of columns. 
int columns = 256;
int w;                // the width of each cell
int visrows;          // Used to determine how many rows are to be rendered to the window
int rule = 30;        // Rule 30 for randonmess, rule 222 for uniformity, rule 190 for repetition, rule 90 for fractal pattern, 110 for complex system.
// Rule 225 is also interesting (set "repeats" to 300, and "columns" to 500).. what looks simple at first can lead to complete chaos.
int[] ruleset = new int[8];
boolean randomStart = false;    // set this to true in order start with a randomized initial seed. Setting this to false starts the seed with a single value set to "1" in the middle.
int[][] cells;        // all cellular automatons will be 

void setup() {
  size(1075, 650);

  //frame.toFront();
  frame.requestFocus(); // needed to bring focus to the window.
  w = (width - 50) / columns;
  visrows = height/w;

  //convert rule number to binary ruleset
  String ruleStr = binary(rule);
  for (int i = 0; i < 8; i++) {
    ruleset[7-i] = int(ruleStr.substring(ruleStr.length()-(i+1), ruleStr.length()-i));
  }
  cells = new int[columns * repeats][columns];
  if (randomStart) {
    for (int i = 0; i < columns; i++) {
      cells[0][i] = floor(random(2));
    }
  } else {
    cells[0][columns/2] = 1;              // 1 in the middle
  }
  for (int i = 0; i < (columns * repeats)-1; i++) {
    for (int j = 0; j < columns; j++) {
      int left, mid, right;
      if (j == 0) {
        left = cells[i][columns-1];
      } else {
        left = cells[i][j-1];
      }
      mid = cells[i][j];
      if (j == columns - 1) {
        right = cells[i][0];
      } else {
        right = cells[i][j+1];
      }
      cells[i+1][j] = ruleset[7 - ((left * 4) + (mid * 2) + right)];
    }
  }
}

void draw() {
  background(255);  

  //SCROLL
  //stroke(255,0,0);
  //noFill();
  pageLength = columns * w * repeats;
  scrollLength = (height/pageLength)*height;
  scrollEnd = scrollLength + scrollStart;
  if (mouseX > width-14 && mouseY > 0 && mouseY < height || scrolling == true) {
    if (scrollWidth < 14) {
      scrollWidth +=1;
    }
  } else {
    if (scrollWidth > 4) {
      scrollWidth -= 1;
    }
  }
  if (mousePressed==true) {
    if (mouseX > width-14 && mouseY > scrollStart && mouseY < scrollEnd) { 
      scrolling = true;
    }
    if (scrolling == true) {
      scrollStart = scrollStart - (pmouseY - mouseY);
      y = y + ((pmouseY - mouseY)/ ( height / pageLength));
    }
  } else {
    scrolling = false;
  }
  //scroll limits..
  if (scrollStart <= 0) {
    scrollStart = 0;
  }
  if (scrollStart > height - scrollLength) {
    scrollStart = height - scrollLength;
  }
  //page limits..
  if (y >= 0) {
    y = 0;
  }
  if (y < - pageLength + height) {
    y = - pageLength + height;
  }

  // draw scroll
  noStroke();  
  fill(255, 0, 0);
  rectMode(CORNER);
  rect(width-scrollWidth, 0, scrollWidth, height);
  fill(0, 255, 0);
  rect(width-scrollWidth, scrollStart, scrollWidth, scrollLength);
  // END SCROLL---------------------------

  fill(0);
  noStroke();
  //for (int j = 0; j < columns * repeats; j++) {    // ** use this line to produce all blocks and in conjunction with "**" below 
  int spacing = (width - (w*columns))/2;
  for (int j = 0; j < height/w; j++) {
    for (int i = 0; i < columns; i++) {      //starts from index 1 because index 0 is reserved for populated flag
      if (cells[j - floor(y/w)][i] == 1) {      // - (floor(y)/w)
        //rect((i * w) + spacing, (j * w) + y + 2, w, w);  // **
        rect((i * w) + spacing, (j * w) + 2, w, w);
      }
    }
  }
  stroke(0);
  //line(0, -2 + y, width, pageLength + y); // scroll testing
}
