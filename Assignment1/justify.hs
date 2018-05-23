import Data.List
import Data.Char

-- ========================================================================================================================== --
{-
	README:
	Name: Abdulhadi Sultan Qureshi
	Roll number: 2020-10-0065

	There are no known faults. I have tried with all the given examples and a few test cases I made myself and have gotten the correct results.
	
	P.S. If you want the exact output given below putStr(unlines (justifyText lineCost enHyp 15 text1)) will give you the exact output but it's of type IO and doesn't match
	the given Type Signature for justifyText.
-}

--
--                                                          ASSIGNMENT 1
--
--      A common type of text alignment in print media is "justification", where the spaces between words, are stretched or
--      compressed to align both the left and right ends of each line of text. In this problem we'll be implementing a text
--      justification function for a monospaced terminal output (i.e. fixed width font where every letter has the same width).
--
--      Alignment is achieved by inserting blanks and hyphenating the words. For example, given a text:
--
--              "He who controls the past controls the future. He who controls the present controls the past."
--
--      we want to be able to align it like this (to a width of say, 15 columns):
--
--              He who controls
--              the  past cont-
--              rols  the futu-
--              re. He  who co-
--              ntrols the pre-
--              sent   controls
--              the past.
--


-- ========================================================================================================================== --



text1 = "He who controls the past controls the future. He who controls the present controls the past."
text2 = "A creative man is motivated by the desire to achieve, not by the desire to beat others."


-- ========================================================================================================================== --







-- ========================================================= PART 1 ========================================================= --


--
-- Define a function that splits a list of words into two lists, such that the first list does not exceed a given line width.
-- The function should take an integer and a list of words as input, and return a pair of lists.
-- Make sure that spaces between words are counted in the line width.
--
-- Example:
--    splitLine ["A", "creative", "man"] 12   ==>   (["A", "creative"], ["man"])
--    splitLine ["A", "creative", "man"] 11   ==>   (["A", "creative"], ["man"])
--    splitLine ["A", "creative", "man"] 10   ==>   (["A", "creative"], ["man"])
--    splitLine ["A", "creative", "man"] 9    ==>   (["A"], ["creative", "man"])
--


splitLine :: [String] -> Int -> ([String], [String])
-- Function definition here
splitLine [] y = ([],[])
splitLine (x:xs) y 
 | length x <= y = ([x]++fst(splitLine xs ((y-1) - length x)), []++snd(splitLine xs ((y-1) - length x)))
 | otherwise = ([], x:xs)





-- ========================================================= PART 2 ========================================================= --


--
-- To be able to align the lines nicely. we have to be able to hyphenate long words. Although there are rules for hyphenation
-- for each language, we will take a simpler approach here and assume that there is a list of words and their proper hyphenation.
-- For example:

enHyp = [("creative", ["cr","ea","ti","ve"]), ("controls", ["co","nt","ro","ls"]), ("achieve", ["ach","ie","ve"]), ("future", ["fu","tu","re"]), ("present", ["pre","se","nt"]), ("motivated", ["mot","iv","at","ed"]), ("desire", ["de","si","re"]), ("others", ["ot","he","rs"])]


--
-- Define a function that splits a list of words into two lists in different ways. The first list should not exceed a given
-- line width, and may include a hyphenated part of a word at the end. You can use the splitLine function and then attempt
-- to breakup the next word with a given list of hyphenation rules. Include a breakup option in the output only if the line
-- width constraint is satisfied.
-- The function should take a hyphenation map, an integer line width and a list of words as input. Return pairs of lists as
-- in part 1.
--
-- Example:
--    lineBreaks enHyp 12 ["He", "who", "controls."]   ==>   [(["He","who"], ["controls."]), (["He","who","co-"], ["ntrols."]), (["He","who","cont-"], ["rols."])]
--
-- Make sure that words from the list are hyphenated even when they have a trailing punctuation (e.g. "controls.")
--
-- You might find 'map', 'find', 'isAlpha' and 'filter' useful.
--

-- getFirst :: ([String], [String]) -> String
-- getFirst (x, y)
--  | y == [] = []
--  | otherwise = y!!0

-- checkAlpha :: String -> [Bool]
-- checkAlpha st = map (\x -> isAlpha x) st

-- filterTrue :: [Bool] -> String -> String
-- filterTrue [] _ = []
-- filterTrue (x:xs) (y:ys)
--  | x == True = [y] ++ filterTrue xs ys
--  | otherwise = filterTrue xs ys

-- filterFalse :: [Bool] -> String -> String
-- filterFalse [] _ = []
-- filterFalse (x:xs) (y:ys)
--  | x == False = [y] ++ filterFalse xs ys
--  | otherwise = filterFalse xs ys

-- lookUp :: [(String, [String])] -> String -> [String]
-- lookUp [] _ = []
-- lookUp (x:xs) y
--  | fst(x) == y = snd(x)
--  | otherwise = lookUp xs y

-- elem' :: String -> [(String, [String])] -> [String]


-- lineBreaks :: [(String, [String])] -> Int -> [String] -> [([String], [String])]
-- lineBreaks lst w (x:xs) = let
--  brk = splitLine (x:xs) w
--  firststr = getFirst brk
--  alphaArr = checkAlpha firststr
--  wop = filterTrue alphaArr firststr
--  punc = filterFalse alphaArr firststr
--  second = lookUp wop
--Helper functions: 
elem' [] y = []
elem' (x:xs) y
 |fst(x)==y = snd(x)
 |chk(applyToAll isAlpha y) == [False] = let
 withoutPunctuation = filter' (applyToAll isAlpha y) (y)
 punctuation = getPunc (applyToAll isAlpha y) (y)
 ans = elem' (x:xs) withoutPunctuation
 finans = addToAll ans punctuation
 in
 finans
 |otherwise = elem' xs y

-- returns with the snd of the tuple if found.

applyToAll f [] = []
applyToAll f (x:xs) = [f(x)]++ applyToAll f xs

addToAll [] p= []
addToAll (x:[]) p= [x++p]
addToAll (x:xs) p= [x] ++ addToAll xs p
 
chk [] = [] 
chk (x:xs)
 | x==True = chk xs
 | otherwise = [False]

filter' [] _ = []
filter' _ [] = []
filter' (x:xs) (y:ys) 
 |x==True = [y]++ filter' xs ys
 |otherwise = []++ filter' xs ys

getPunc _ [] = []
getPunc (x:xs) (y:ys) 
 |x==False = [y]++ getPunc xs ys
 |otherwise = []++ getPunc xs ys

combinationz [] = []
combinationz (x:[]) = []
combinationz (x:y:xs) = [((x++"-"), conc (y:xs))]++ combinationz ((x++y):xs)
--creates different permutations
--combinationz ["co","nt","ro","ls"] == [("co-","ntrols"),("cont-","rols"),("contro-","ls")]

conc [] = ""
conc (x:xs) = x ++ conc xs
--concatenates strings

check' lst (x:_) = elem' lst x

combineList [] (y:ys) (f:fs)=   []
combineList (x:xs) (y:ys) (f:fs) =  [(f:fs)++[fst(x)]++[snd(x)]++ys]++combineList xs (y:ys) (f:fs)
--combineList [("co-","ntrols"),("cont-","rols"),("contro-","ls")]["He","who"] ["controls", "earth"]  == [["He","who","co-","ntrols","earth"],["He","who","cont-","rols","earth"],["He","who","contro-","ls","earth"]]

combListwHyp lst (x:_) spl
 | elem' lst x == [] = []
 | otherwise = let
 comb = combinationz(elem' lst x)
 cl = combineList comb (snd(spl)) (fst(spl))
 in
 cl

checkSplit spl [] w = []
checkSplit spl (x:xs) w
 | fst(splitLine x w)==fst(spl) = []
 | otherwise = [(splitLine x w)] ++ (checkSplit spl xs w)

lineBreaks :: [(String, [String])] -> Int -> [String] -> [([String], [String])]
-- Function definition here
lineBreaks lst w [] = []
lineBreaks lst w (x:xs) 
 | snd(splitLine (x:xs) w) == [] = [splitLine (x:xs) w]
 | (check' lst (snd(splitLine (x:xs) w))) == [] = [splitLine (x:xs) w]
 | otherwise = let
 combined = combListwHyp lst (snd(splitLine (x:xs) w)) (splitLine (x:xs) w)
 ans = checkSplit (splitLine (x:xs) w) combined w
 finans = ([splitLine (x:xs) w]) ++ ans
 in
 finans





-- ========================================================= PART 3 ========================================================= --


--
-- Define a function that inserts a given number of blanks (spaces) into a list of strings and outputs a list of all possible
-- insertions. Only insert blanks between strings and not at the beginning or end of the list (if there are less than two
-- strings in the list then return nothing). Remove duplicate lists from the output.
-- The function should take the number of blanks and the the list of strings as input and return a lists of strings.
--
-- Example:
--    blankInsertions 2 ["A", "creative", "man"]   ==>   [["A", " ", " ", "creative", "man"], ["A", " ", "creative", " ", "man"], ["A", "creative", " ", " ", "man"]]
--
-- Use let/in/where to make the code readable
--

--Helper functions: 
addstring s [] = []
addstring s (x:xs) = ([[s]++x]) ++ (addstring s xs)

removemults [] = []
removemults (x:[]) = [x]
removemults (x:y:xs) 
 | x==y = removemults (y:xs)
 | otherwise = [x]++removemults (y:xs)

multInsertions [] = []
multInsertions (x:xs) = removemults ((blankInsertions 1 x) ++ (multInsertions xs))

rcall y (x:xs) 
 | y == 2 = multInsertions (x:xs)
 | otherwise = rcall (y-1) (multInsertions (x:xs))

blankInsertions :: Int -> [String] -> [[String]]
-- Function definition here
blankInsertions y [] = []
blankInsertions y (x:[])=[]
blankInsertions y (x:xs)
 | y==0 = [x:xs]
 | x==" " = addstring x (blankInsertions y xs)
 | y==1 = [[x]++[" "]++xs]++(addstring x (blankInsertions y xs))
 | otherwise = let
 first = blankInsertions 1 (x:xs)
 rest = rcall y first
 in
 rest





-- ========================================================= PART 4 ========================================================= --


--
-- Define a function to score a list of strings based on four factors:
--
--    blankCost: The cost of introducing each blank in the list
--    blankProxCost: The cost of having blanks close to each other
--    blankUnevenCost: The cost of having blanks spread unevenly
--    hypCost: The cost of hyphenating the last word in the list
--
-- The cost of a list of strings is computed simply as the weighted sum of the individual costs. The blankProxCost weight equals
-- the length of the list minus the average distance between blanks (0 if there are no blanks). The blankUnevenCost weight is
-- the variance of the distances between blanks.
--
-- The function should take a list of strings and return the line cost as a double
--
-- Example:
--    lineCost ["He", " ", " ", "who", "controls"]
--        ==>   blankCost * 2.0 + blankProxCost * (5 - average(1, 0, 2)) + blankUnevenCost * variance(1, 0, 2) + hypCost * 0.0
--        ==>   blankCost * 2.0 + blankProxCost * 4.0 + blankUnevenCost * 0.666...
--
-- Use let/in/where to make the code readable
--


---- Do not modify these in the submission ----
blankCost = 1.0
blankProxCost = 1.0
blankUnevenCost = 1.0
hypCost = 1.0
-----------------------------------------------

countBlankula [] = 0
countBlankula (x:xs) 
 | x==" " = 1 + countBlankula xs
 | otherwise = countBlankula xs

countBlankProx [] y = [fromIntegral (y)]
countBlankProx (x:xs) y
 | x == " " = [fromIntegral (y)] ++ countBlankProx xs 0 
 | otherwise = countBlankProx xs (y+1)

charcomp c [] = 0
charcomp c (x:xs)
 | x == c = 1 + charcomp c xs
 | otherwise = charcomp c xs

countHypula [] = 0
countHypula (x:xs) = (charcomp ('-') x) + countHypula xs

sizeCounter [] = 0
sizeCounter (x:xs) = 1 + sizeCounter xs

average' [] y = 0
average' (x:xs) y = (x/y) + average' xs y


var _ [] _ = 0
var avg (x:xs) sz = ((x-avg)*(x-avg))/sz + (var avg xs sz)

length' [] = 0
length' (x:xs) = 1 + length' xs

lineCost :: [String] -> Double
lineCost [] = 0
lineCost x 
 | x == [] = 0
 | otherwise = let 
 blanks = countBlankula x
 proxarr = countBlankProx x 0
 sz = fromIntegral (sizeCounter proxarr)
 avg = average' proxarr sz
 v = var avg proxarr sz
 hyps = countHypula x
 finans = (blankCost*blanks) + (blankProxCost*(length' (x)-avg)) + (blankUnevenCost*v) + (hypCost*hyps)
 in
 finans






-- ========================================================= PART 5 ========================================================= --


--
-- Define a function that returns the best line break in a list of words given a cost function, a hyphenation map and the maximum
-- line width (the best line break is the one that minimizes the line cost of the broken list).
-- The function should take a cost function, a hyphenation map, the maximum line width and the list of strings to split and return
-- a pair of lists of strings as in part 1.
--
-- Example:
--    bestLineBreak lineCost enHyp 12 ["He", "who", "controls"]   ==>   (["He", "who", "cont-"], ["rols"])
--
-- Use let/in/where to make the code readable
--

len [] = 0
len (x:[]) = length x
len (x:xs) = length x + 1 + len xs

lenarr [] = []
lenarr (x:xs) = [len (fst(x))]++ lenarr xs

addblank [] w _= []
addblank (x:xs) w (l:ls) = blankInsertions (w-l) (fst(x)) ++ addblank xs w ls

costchecker lc [] = []
costchecker lc (x:xs) = [lc x]++ costchecker lc xs

min' (x:[]) = x
min' (x:xs) 
 | x < min'(xs) = x
 | otherwise = min'(xs)

findlowest [] _ _ = []
findlowest (c:cs) (x:xs) y 
 | y == c = x
 | otherwise = findlowest cs xs y

getLast [] = []
getLast (x:[]) = x
getLast (x:xs) = getLast xs 

checkLast _ [] _ = ([],[])
checkLast s (x:xs) f
 | s == getLast (fst(x)) = (f, snd(x))
 | otherwise = checkLast s xs f

bestLineBreak :: ([String] -> Double) -> [(String, [String])] -> Int -> [String] -> ([String], [String])
-- Function definition here
bestLineBreak lc lst w [] = ([],[])
bestLineBreak lc lst w (x:xs)
 | 1==1 = let
 lb = lineBreaks lst w (x:xs)
 l = lenarr lb
 badd = addblank lb w l
 c = costchecker lc badd
 mc = min' c
 fl = findlowest c badd mc
 last = getLast fl
 finans = checkLast last lb fl
 in
 finans


--
-- Finally define a function that justifies a given text into a list of lines satisfying a given width constraint.
-- The function should take a cost function, hyphenation map, maximum line width, and a text string as input and return a list of
-- strings.
--
-- 'justifyText lineCost enHyp 15 text1' should give you the example at the start of the assignment.
--
-- You might find the words and unwords functions useful.
--

convertoarr :: String -> String
convertoarr [] = []
convertoarr (t:ts) 
 | t /= ' ' = [t]++convertoarr ts
 | otherwise = []

shorten [] = []
shorten (t:ts)
 |t==' ' = ts
 |otherwise = shorten ts

arrayConvertToList [] = []
arrayConvertToList s 
 | 1==1 = let
 fw = convertoarr s
 rest = shorten s
 ans = [fw]++arrayConvertToList rest
 in
 ans

bestLineBreak' _ _ _ [] = []
bestLineBreak' lc lst w s
 | len s <= w = [s] 
 | 1==1 = let
 lb = bestLineBreak lc lst w s
 ans = [fst(lb)] ++ bestLineBreak' (lc) (lst) (w) (snd(lb))
 in
 ans
--lbp lc lst w t
 
convertToString (x:[]) = x
convertToString (x:xs) = x++" "++convertToString xs

arrconvertToString [] = []
arrconvertToString (x:xs) = [convertToString x]++arrconvertToString xs

--(["He", "who", "cont-"], ["rols"])
justifyText :: ([String] -> Double) -> [(String, [String])] -> Int -> String -> [String] 
-- Function definition here
justifyText lc lst w t 
 | 1==1 = let
 actl = arrayConvertToList t
 ba = bestLineBreak' lc lst w actl
 s = arrconvertToString ba
 in
 s 














