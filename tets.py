import unittest

from Map_Generated import Game
class MinesweeperTest(unittest.TestCase):
    def test_board1(self):
       array = [['-','X', '-','-','X','-'],['-','-','X','-','-','-'],['-','-','-','-','X','-'],['-','-','-','X','-','X'],['-','X','-','-','X','-'],['-','-','-','-','-','-']]
       #  inp = ["+------+",
       #         "| X  X |",
       #         "|  X   |",
       #         "|    X |",
       #         "|   X X|",
       #         "| X  X |",
       #         "|      |",
       #         "+------+"]
       moves = ["right", "center"]
       result = Game(array, moves)
       #  out = ["+------+",
       #         "|1X22X1|",
       #         "|12X322|",
       #         "|0123X2|",
       #         "|112X4X|",
       #         "|1X22X2|",
       #         "|111111|",
       #         "+------+"]
       out = [[1,'X', 2,2,'X',1],[1,2,'X',3,2,2],[0,1,2,3,'X',2],[1,1,2,'X',4,'X'],[1,'X',2,2,'X',2],[1,1,1,1,1,1]]
       self.assertEqual(result,out)
if __name__ == '__main__':
    unittest.main()
