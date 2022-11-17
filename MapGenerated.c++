// dir == 0 (left), 1 (right), 2(up), 3(down), 4(center)
struct dir{
	bool left = 0, right = 0, up = 0, down = 0, center = 0;
};
// A C++ Program to Implement and Play Minesweeper
// without taking input from user

#include<bits/stdc++.h>
using namespace std;

#define TIME  0.1
#define MAXSIDE 25
#define MAXMINES 99
#define MOVESIZE 526 // (25 * 25 - 99)

int SIDE ; // side length of the board
int MINES ; // number of mines on the board

// A Utility Function to check whether given cell (row, col)
// is a valid cell or not
bool isValid(int row, int col)
{
	// Returns true if row number and column number
	// is in range
	return (row >= 0) && (row < SIDE) &&
		(col >= 0) && (col < SIDE);
}

// A Utility Function to check whether given cell (row, col)
// has a mine or not.
bool isMine (int row, int col, char board[][MAXSIDE])
{
	if (board[row][col] == '*')
		return (true);
	else
		return (false);
}

// A Function to get the user's move and print it
// All the moves are assumed to be distinct and valid.
void makeMove (int x, int y, dir moves,char board[][MAXSIDE])
{
	if(moves.left == 1 && isValid(x-1, y)) x -= 1;
	if(moves.right == 1 && isValid(x+1, y)) x += 1;
	if(moves.up == 1 && isValid(x, y+1)) y+=1;
	if(moves.down == 1 && isValid(x, y-1)) y-=1;
	//single click: flag the tile 
	if(moves.center == 1 && isValid(x,y)) board[x][y] = '?';
	printf ("\nMy move is (%d, %d)\n", x, y);

	/*
	// The above moves are pre-defined
	// If you want to make your own move
	// then uncomment this section and comment
	// the above section

	scanf("%d %d", x, y);
	*/

	return;
}


// A Function to print the current gameplay board
void printBoard(char board[][MAXSIDE])
{
	int i,j;

	printf (" ");

	for (i=0; i<SIDE; i++)
		printf ("%d ", i);

	printf ("\n\n");

	for (i=0; i<SIDE; i++)
	{
		printf ("%d ", i);

		for (j=0; j<SIDE; j++)
			printf ("%c ", board[i][j]);
		printf ("\n");
	}
	return;
}

// A Function to count the number of
// mines in the adjacent cells
int countAdjacentMines(int row ,int col ,int mines[][2], char board[][MAXSIDE])
{

	int i;
	int count = 0;


	//----------- 1st Neighbour (North) ------------

		// Only process this cell if this is a valid one
		if (isValid (row-1, col) == true)
		{
			if (isMine (row-1, col, board) == true)
			count++;
		}

	//----------- 2nd Neighbour (South) ------------

		// Only process this cell if this is a valid one
		if (isValid (row+1, col) == true)
		{
			if (isMine (row+1, col, board) == true)
			count++;
		}

	//----------- 3rd Neighbour (East) ------------

		// Only process this cell if this is a valid one
		if (isValid (row, col+1) == true)
		{
			if (isMine (row, col+1, board) == true)
			count++;
		}

	//----------- 4th Neighbour (West) ------------

		// Only process this cell if this is a valid one
		if (isValid (row, col-1) == true)
		{
			if (isMine (row, col-1, board) == true)
			count++;
		}

	//----------- 5th Neighbour (North-East) ------------

		// Only process this cell if this is a valid one
		if (isValid (row-1, col+1) == true)
		{
			if (isMine (row-1, col+1, board) == true)
			count++;
		}

	//----------- 6th Neighbour (North-West) ------------

		// Only process this cell if this is a valid one
		if (isValid (row-1, col-1) == true)
		{
			if (isMine (row-1, col-1, board) == true)
			count++;
		}

	//----------- 7th Neighbour (South-East) ------------

		// Only process this cell if this is a valid one
		if (isValid (row+1, col+1) == true)
		{
			if (isMine (row+1, col+1, board) == true)
			count++;
		}

	//----------- 8th Neighbour (South-West) ------------

		// Only process this cell if this is a valid one
		if (isValid (row+1, col-1) == true)
		{
			if (isMine (row+1, col-1, board) == true)
			count++;
		}

	return (count);
}

// A Recursive Function to play the Minesweeper Game
bool playMinesweeperUtil(char board[][MAXSIDE],
			int mines[][2], int row, int col, int *movesLeft)
{

	// Base Case of Recursion
	if (board[row][col]!='-')
		return (false);

	int i, j;

	// You opened a mine
	// You are going to lose
	if (board[row][col] == '*')
	{

		for (i=0; i<MINES; i++)
			board[mines[i][0]][mines[i][1]]='*';

		printBoard (board);
		printf ("\nYou lost!\n");
		return (true) ;
	}

	else
	{

		// Calculate the number of adjacent mines and put it
		// on the board.
		int count = countAdjacentMines(row, col, mines, board);
		(*movesLeft)--;

		board[row][col] = count + '0';

		if (!count)
		{

				//----------- 1st Neighbour (North) ------------

			// Only process this cell if this is a valid one
			if (isValid (row-1, col) == true)
			{
				if (isMine (row-1, col, board) == false)
				playMinesweeperUtil( board, mines, row-1, col, movesLeft);
			}

			//----------- 2nd Neighbour (South) ------------

			// Only process this cell if this is a valid one
			if (isValid (row+1, col) == true)
			{
				if (isMine (row+1, col, board) == false)
					playMinesweeperUtil( board, mines, row+1, col, movesLeft);
			}

			//----------- 3rd Neighbour (East) ------------

			// Only process this cell if this is a valid one
			if (isValid (row, col+1) == true)
			{
				if (isMine (row, col+1, board) == false)
					playMinesweeperUtil( board, mines, row, col+1, movesLeft);
			}

			//----------- 4th Neighbour (West) ------------

			// Only process this cell if this is a valid one
			if (isValid (row, col-1) == true)
			{
				if (isMine (row, col-1, board) == false)
					playMinesweeperUtil( board, mines, row, col-1, movesLeft);
			}

			//----------- 5th Neighbour (North-East) ------------

			// Only process this cell if this is a valid one
			if (isValid (row-1, col+1) == true)
			{
				if (isMine (row-1, col+1, board) == false)
					playMinesweeperUtil( board, mines, row-1, col+1, movesLeft);
			}

			//----------- 6th Neighbour (North-West) ------------

			// Only process this cell if this is a valid one
			if (isValid (row-1, col-1) == true)
			{
				if (isMine (row-1, col-1, board) == false)
					playMinesweeperUtil( board, mines, row-1, col-1, movesLeft);
			}

			//----------- 7th Neighbour (South-East) ------------

			// Only process this cell if this is a valid one
			if (isValid (row+1, col+1) == true)
			{
				if (isMine (row+1, col+1, board) == false)
					playMinesweeperUtil( board, mines, row+1, col+1, movesLeft);
			}

			//----------- 8th Neighbour (South-West) ------------

			// Only process this cell if this is a valid one
			if (isValid (row+1, col-1) == true)
			{
				if (isMine (row+1, col-1, board) == false)
					playMinesweeperUtil( board, mines, row+1, col-1, movesLeft);
			}
		}

		return (false);
	}
}

// A Function to place the mines randomly
// on the board
void placeMines(int mines[][2], char board[][MAXSIDE])
{
	bool mark[MAXSIDE*MAXSIDE];

	memset (mark, false, sizeof (mark));

	// Continue until all random mines have been created.
	for (int i=0; i<MINES; )
	{
		int random = rand() % (SIDE*SIDE);
		int x = random / SIDE;
		int y = random % SIDE;

		// Add the mine if no mine is placed at this
		// position on the board
		if (mark[random] == false)
		{
			// Row Index of the Mine
			mines[i][0]= x;
			// Column Index of the Mine
			mines[i][1] = y;

			// Place the mine
			board[mines[i][0]][mines[i][1]] = '*';
			mark[random] = true;
			i++;
		}
	}

	return;
}

// A Function to initialise the game
void initialise (char board[][MAXSIDE])
{
	// Initiate the random number generator so that
	// the same configuration doesn't arises
	srand (time (NULL));

	// Assign all the cells as mine-free
	for (int i=0; i<SIDE; i++)
	{
		for (int j=0; j<SIDE; j++)
		{
			 board[i][j] = '-';
		}
	}

	return;
}
// A function to replace the mine from (row, col) and put
// it to a vacant space
void replaceMine (int row, int col, char board[][MAXSIDE])
{
	for (int i=0; i<SIDE; i++)
	{
		for (int j=0; j<SIDE; j++)
			{
				// Find the first location in the board
				// which is not having a mine and put a mine
				// there.
				if (board[i][j] != '*')
				{
					board[i][j] = '*';
					board[row][col] = '-';
					return;
				}
			}
	}
	return;
}

// A Function to play Minesweeper game
void playMinesweeper (dir moves)
{
	// Initially the game is not over
	bool gameOver = false;

	// Actual Board and My Board
	char board[MAXSIDE][MAXSIDE];

	int movesLeft = SIDE * SIDE - MINES, x, y;
	int mines[MAXMINES][2]; // Stores (x, y) coordinates of all mines.
   // Stores (x, y) coordinates of the moves

	// Initialise the Game
	initialise (board);

	// Place the Mines randomly
	placeMines (mines, board);

	// Assign Moves
	// If you want to make your own input move,
	// then the below function should be commented
	// assignMoves (moves, movesLeft);

	/*
	//If you want to cheat and know
	//where mines are before playing the game
	//then uncomment this part

	cheatMinesweeper(board);
	*/

	// You are in the game until you have not opened a mine
	// So keep playing

	int currentMoveIndex = 0;
	while (gameOver == false)
	{
		printf ("Current Status of Board : \n");
		printBoard (board);

		makeMove (x, y, moves, board);

		// This is to guarantee that the first move is
		// always safe
		// If it is the first move of the game
		if (currentMoveIndex == 0)
		{
			// If the first move itself is a mine
			// then we remove the mine from that location
			if (isMine (x, y, board) == true)
				replaceMine (x, y, board);
			currentMoveIndex++;
		}

		gameOver = playMinesweeperUtil (board, mines, x, y, &movesLeft);

		if ((gameOver == false) && (movesLeft == 0))
		{
			printf ("\nYou won !\n");
			gameOver = true;
		}
	}

	return;
}

int main()
{
	/* Choose a level between
	--> BEGINNER = 9 * 9 Cells and 10 Mines
	--> INTERMEDIATE = 16 * 16 Cells and 40 Mines
	--> ADVANCED = 24 * 24 Cells and 99 Mines
	*/

}


// A Function to cheat by revealing where the mines are
// placed.
// void cheatMinesweeper (char board[][MAXSIDE])
// {
// 	printf ("The mines locations are-\n");
// 	printBoard (board);
// 	return;
// }



// A Function to choose the difficulty level
// of the game
// void chooseDifficultyLevel (int level)
// {
// 	/*
// 	--> BEGINNER = 9 * 9 Cells and 10 Mines
// 	--> INTERMEDIATE = 16 * 16 Cells and 40 Mines
// 	--> ADVANCED = 24 * 24 Cells and 99 Mines
// 	*/

// 	if (level == BEGINNER)
// 	{
// 		SIDE = 9;
// 		MINES = 10;
// 	}

// 	if (level == INTERMEDIATE)
// 	{
// 		SIDE = 16;
// 		MINES = 40;
// 	}

// 	if (level == ADVANCED)
// 	{
// 		SIDE = 24;
// 		MINES = 99;
// 	}

// 	return;
// }


// A Function to randomly assign moves
// void assignMoves (int moves[][2], int movesLeft)
// {
// 	bool mark[MAXSIDE*MAXSIDE];

// 	memset(mark, false, sizeof(mark));

// 	// Continue until all moves are assigned.
// 	for (int i=0; i<movesLeft; )
// 	{
// 		int random = rand() % (SIDE*SIDE);
// 		int x = random / SIDE;
// 		int y = random % SIDE;

// 		// Add the mine if no mine is placed at this
// 		// position on the board
// 		if (mark[random] == false)
// 		{
// 			// Row Index of the Mine
// 			moves[i][0]= x;
// 			// Column Index of the Mine
// 			moves[i][1] = y;

// 			mark[random] = true;
// 			i++;
// 		}
// 	}

// 	return;
// }