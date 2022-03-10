import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private final static int NUM_MINES = 50;
private String[] Lost = {"Y", "O", "U", " ", "L", "O", "S", "E", "!"};
private String[] Win = {"Y", "O", "U", " ", "W", "I", "N", "!"}; 
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
  
public void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
      
    setMines();
}
public void setMines()
{
    //your code
    while(mines.size() < 50)
    {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c])){
      mines.add(buttons[r][c]);
      //System.out.println(r + "," + c);
    }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    int count = 0; 
    for(int row = 0; row < buttons.length; row++){
      for(int col = 0; col < buttons[row].length; col++){
        if(buttons[row][col].clicked == true)
          count++;
      }
    }
    if(count == ((NUM_COLS*NUM_COLS)-NUM_MINES))
      return true;
    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int row = 0; row < NUM_ROWS; row++){
      for(int col = 0; col < NUM_COLS; col++){
        if(mines.contains(buttons[row][col]))
          buttons[row][col].clicked = true;
      }
    }
    for(int col = 5; col < 14; col++)
      buttons[10][col].setLabel(Lost[(col-5) % Lost.length]);
}
public void displayWinningMessage()
{
    //your code here
    for(int col = 6; col < 14; col++)
      buttons[10][col].setLabel(Win[(col-6) % Win.length]);
}
public boolean isValid(int r, int c)
{
     if (r >= 0 && r < NUM_ROWS && c >=0 && c < NUM_COLS)
      return true;    
     return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    if(mines.contains(row) && mines.contains(col))
      numMines--;
    for(int r = row - 1; r <= row + 1; r++){
      for(int c = col - 1; c <= col + 1; c++){
        if(isValid(r,c) && mines.contains(buttons[r][c]))
          numMines++;
      }
    }
     return numMines;
    }
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if (mouseButton == RIGHT){
          flagged =! flagged;
          if (mouseButton == RIGHT && flagged == false)
            clicked = false;
          }
        else if (mines.contains(this) && flagged == false){
          displayLosingMessage();
        }
        else if (countMines(myRow, myCol) > 0){
          myLabel = countMines(myRow, myCol) + "";
        }
        else{
          for(int r = myRow-1; r <= myRow+1; r++){
            for(int c = myCol-1; c <= myCol+1; c++){
              if(isValid(r,c) == true && buttons[r][c].clicked == false)
                buttons[r][c].mousePressed();
          }
        }
      }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;

    }
    
}
