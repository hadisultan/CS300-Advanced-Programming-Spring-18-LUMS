-- ---------------------------------------------------------------------
-- DNA Analysis 
-- CS300 Spring 2018
-- Due: 24 Feb 2018 @9pm


-- Name: Abdulhadi Sultan Qureshi
-- Roll number: 2020-10-0065

-- README: I was not able to solve the last 2 functions of Part 4, apart from that
-- all of the functions have a working solution. Disclaimer: Part 2, 3 and the 
-- alignment function in part 4 take a little time e.g. around 10 seconds to ge the
-- solution of the DNATree posted by Mujahid in the group for Part 3. In the last
-- function of part 5, I put in extra conditions to not display the start/stop codon.
-- According to my best judgement, we were not supposed to display these codons, but
-- if we were then I hope I don't get penalized for it since it was not specified.

-- ------------------------------------Assignment 2------------------------------------
--
-- >>> YOU ARE NOT ALLOWED TO IMPORT ANY LIBRARY
-- Functions available without import are okay
-- Making new helper functions is okay
--
-- ---------------------------------------------------------------------
--
-- DNA can be thought of as a sequence of nucleotides. Each nucleotide is 
-- adenine, cytosine, guanine, or thymine. These are abbreviated as A, C, 
-- G, and T.
--
type DNA = [Char]
type RNA = [Char]
type Codon = [Char]
type AminoAcid = Maybe String

-- ------------------------------------------------------------------------
-- 				PART 1
-- ------------------------------------------------------------------------				

-- We want to calculate how alike are two DNA strands. We will try to 
-- align the DNA strands. An aligned nucleotide gets 3 points, a misaligned
-- gets 2 points, and inserting a gap in one of the strands gets 1 point. 
-- Since we are not sure how the next two characters should be aligned, we
-- try three approaches and pick the one that gets us the maximum score.
-- 1) Align or misalign the next nucleotide from both strands
-- 2) Align the next nucleotide from first strand with a gap in the second     
-- 3) Align the next nucleotide from second strand with a gap in the first    
-- In all three cases, we calculate score of leftover strands from recursive 
-- call and add the appropriate penalty.                                    
max' :: [Int] -> Int
max' (x:[]) = x
max' (x:xs) 
 |x > max' xs = x
 |otherwise = max' xs 

score :: DNA -> DNA -> Int
score [] [] = 0
score (x:xs) [] = 1 + score xs []
score [] (y:ys) = 1 + score [] ys
score (x:xs) (y:ys)
 | x==y = let
 aln = 3 + score xs ys
 spc1 = 1 + score (x:xs) ys
 spc2 = 1 + score xs (y:ys)
 in
 max' [aln, spc1, spc2]
 | otherwise = let
 misaln = 2+ score xs ys
 spc1 = 1 + score (x:xs) ys
 spc2 = 1 + score xs (y:ys)
 in
 max' [misaln, spc1, spc2]
 

-- -------------------------------------------------------------------------
--				PART 2
-- -------------------------------------------------------------------------
-- Write a function that takes a list of DNA strands and returns a DNA tree. 
-- For each DNA strand, make a separate node with zero score 
-- in the Int field. Then keep merging the trees. The merging policy is:
-- 	1) Merge two trees with highest score. Merging is done by making new
--	node with the smaller DNA (min), and the two trees as subtrees of this
--	tree
--	2) Goto step 1 :)
--

data DNATree = Node DNA Int DNATree DNATree | Nil deriving (Ord, Show, Eq)

dnatodtree :: [DNA] -> [DNATree]
dnatodtree [] = []
dnatodtree (x:xs) = [(Node x 0 Nil Nil)] ++ dnatodtree xs

--calculatePairs [Node "ATAG" 0 Nil Nil,Node "TG" 0 Nil Nil,Node "CTGA" 0 Nil Nil,Node "CAAAA" 0 Nil Nil] == [(8,(Node "ATAG" 0 Nil Nil,Node "TG" 0 Nil Nil)),(10,(Node "ATAG" 0 Nil Nil,Node "CTGA" 0 Nil Nil)),(11,(Node "ATAG" 0 Nil Nil,Node "CAAAA" 0 Nil Nil)),(11,(Node "CTGA" 0 Nil Nil,Node "CAAAA" 0 Nil Nil)),(8,(Node "TG" 0 Nil Nil,Node "CTGA" 0 Nil Nil)),(7,(Node "TG" 0 Nil Nil,Node "CAAAA" 0 Nil Nil)),(11,(Node "CTGA" 0 Nil Nil,Node "CAAAA" 0 Nil Nil))]

calculatePairs :: [DNATree] -> [(Int, (DNATree, DNATree))]
calculatePairs [] = []
calculatePairs (x:[]) = []
calculatePairs ((Node x x1 x2 x3 ):(Node y y1 y2 y3 ):xs) = let
 scr = score x y
 tpl = (scr, ((Node x x1 x2 x3), (Node y y1 y2 y3)))
 in
 [tpl]++calculatePairs ((Node x x1 x2 x3):xs)++calculatePairs((Node y y1 y2 y3):xs)

maxPair :: [(Int, (DNATree, DNATree))] -> (Int, (DNATree, DNATree))
maxPair (x:[]) = x
maxPair ((x, y): xs)
 | x>fst(maxPair xs) = (x, y)
 | otherwise = maxPair xs

-- addToAll :: DNATree -> [DNATree] ->[DNATree]
-- addToAll _ [] = []
-- addToAll z (x:xs) = z++

removePair :: (Int, (DNATree, DNATree)) -> [DNATree] -> [DNATree]
removePair _ [] = []
removePair ( z ,(Node y1 y11 y12 y13 ,Node y2 y21 y22 y23 )) ((Node x x1 x2 x3 ):xs)
 | y1 == x = removePair (z, (Node "" y11 y12 y13, (Node y2 y21 y22 y23))) (xs)
 | y2 == x = removePair (z, ((Node y1 y11 y12 y13), Node "" y21 y22 y23)) (xs)
 | otherwise = [(Node x x1 x2 x3)]++removePair (z,((Node y1 y11 y12 y13),(Node y2 y21 y22 y23))) (xs)

findMinLen :: (DNATree, DNATree) -> DNA
findMinLen (Node x _ _ _ , Node y _ _ _ )
 | length(y) > length(x) = x
 | otherwise = y   

findMaxNode :: DNATree -> DNATree -> DNATree
findMaxNode (Node y y1 y2 y3) (Node z z1 z2 z3) 
 | z1 > y1 = (Node z z1 z2 z3)
 | otherwise = (Node y y1 y2 y3)

findMinNode :: DNATree -> DNATree -> DNATree
findMinNode (Node y y1 y2 y3) (Node z z1 z2 z3) 
 | z1 <= y1 = (Node z z1 z2 z3)
 | otherwise = (Node y y1 y2 y3)

makeNode :: (Int, (DNATree, DNATree)) -> DNATree
makeNode (x,(Node y y1 y2 y3, Node z z1 z2 z3 )) = let
 st = min y z
 maxnode = findMaxNode (Node y y1 y2 y3) (Node z z1 z2 z3)
 minnode = findMinNode (Node y y1 y2 y3) (Node z z1 z2 z3)
 in
 (Node st (x) minnode maxnode)

oneTree :: [DNATree] -> DNATree
oneTree [] = Nil
oneTree (x:[]) = x
oneTree x = let
 cP = calculatePairs x
 mP = maxPair cP
 rm = removePair mP x
 mkN = makeNode mP
 finarr = rm ++ [mkN]
 in 
 oneTree finarr

makeDNATree :: [DNA] -> DNATree
makeDNATree [] = Nil
makeDNATree (x:[]) = (dnatodtree [x])!!0
makeDNATree (x:xs) = let
 dtreearr = dnatodtree (x:xs)
 otree = oneTree dtreearr
 in
 otree



-- putStr (draw (Node "AACCTTGG" 20 (Node "ATATTATA" 0 Nil Nil) (Node "AACCTTGG" 20 (Node "ACTACACC" 0 Nil Nil) (Node "AACCTTGG" 21 (Node "AACCTTGG" 0 Nil Nil) (Node "ACTGCATG" 0 Nil Nil)))))
-- putStr (draw (Node "AACCTTGG" 20 (Node "ATATTATA" 0 Nil Nil) (Node "AACCTTGG" 20 (Node "ACTACACC" 0 Nil (Node "ACTGCATG" 0 Nil Nil)) (Node "AACCTTGG" 21 (Node "AACCTTGG" 0 Nil Nil) (Node "ACTGCATG" 0 Nil Nil)))))
-- -------------------------------------------------------------------------
--				PART 3
-- -------------------------------------------------------------------------

-- Even you would have realized it is hard to debug and figure out the tree
-- in the form in which it currently is displayed. Lets try to neatly print 
-- the DNATree. Each internal node should show the 
-- match score while leaves should show the DNA strand. In case the DNA strand 
-- is more than 10 characters, show only the first seven followed by "..." 
-- The tree should show like this for an evolution tree of
-- ["AACCTTGG","ACTGCATG", "ACTACACC", "ATATTATA"]
--
-- 20
-- +---ATATTATA
-- +---21
--     +---21
--     |   +---ACTGCATG
--     |   +---ACTACACC
--     +---AACCTTGG
--
-- Make helper functions as needed. It is a bit tricky to get it right. One
-- hint is to pass two extra string, one showing what to prepend to next 
-- level e.g. "+---" and another to prepend to level further deep e.g. "|   "

child :: DNATree -> [Char] -> [Char]
child (Nil) _ = []
child (Node x x1 Nil Nil) _ = []
child (Node x x1 x2 x3) s = let
 nl = "\n"++s
 nnl = "|   "++s
 nlleft = nl ++ nodeOrNil x2 ++ child (x2) (nnl)
 nlright = nl ++ nodeOrNil x3 ++ child (x3) (nnl)
 in
 nlleft ++ nlright


nodeOrNil :: DNATree -> [Char]
nodeOrNil (Nil) = []
nodeOrNil (Node x x1 Nil Nil) = x
nodeOrNil (Node x x1 _ _) = show(x1)


draw :: DNATree -> [Char]
draw (Nil) = []
draw (Node x x1 x2 x3) = let
 numberr = show(x1)
 rest ="\n+---" ++ nodeOrNil(x2) ++ child (x2) ("|   +---") ++ "\n+---" ++ nodeOrNil(x3) ++ child (x3) ("|   +---")
 in
 numberr ++ rest ++ "\n"

-- ---------------------------------------------------------------------------
--				PART 4
-- ---------------------------------------------------------------------------
--
--
-- Our score function is inefficient due to repeated calls for the same 
-- suffixes. Lets make a dictionary to remember previous results. First you
-- will consider the dictionary as a list of tuples and write a lookup
-- function. Return Nothing if the element is not found. Also write the 
-- insert function. You can assume that the key is not already there.
type Dict a b = [(a,b)]

lookupDict :: (Eq a) => a -> Dict a b -> Maybe b
lookupDict _ [] = Nothing
lookupDict y (x:xs)
 | y == fst(x) = Just (snd(x))
 | otherwise = lookupDict y xs



insertDict :: (Eq a) => a -> b -> (Dict a b)-> (Dict a b)
insertDict x y z = let
 tup = (x, y)
 in
 z ++ [tup]

-- We will improve the score function to also return the alignment along
-- with the score. The aligned DNA strands will have gaps inserted. You
-- can represent a gap with "-". You will need multiple let expressions 
-- to destructure the tuples returned by recursive calls.

max'' :: [((String, String), Int)] -> ((String, String), Int)
max'' (x:[]) = x
max'' (x:xs)
 | (snd(x)) > (snd(max'' xs)) = x
 | otherwise = max'' xs
 
alignment :: String -> String -> ((String, String), Int)
alignment [] [] = (("",""), 0)
alignment (x:xs) [] = (([x] ++ fst(fst(alignment xs [])), "-" ++ snd(fst(alignment xs [])) ), 1 + snd(alignment xs []) )
alignment [] (y:ys) = (("-" ++ fst(fst(alignment [] ys)), [y] ++ snd(fst(alignment [] ys)) ), 1 + snd(alignment [] ys) )
alignment (x:xs) (y:ys) 
 | x == y = let
 aln = (([x] ++ fst(fst(alignment xs ys)), [y] ++ snd(fst(alignment xs ys))), 3 + snd(alignment xs ys))
 spc1 = (("-" ++ fst(fst(alignment (x:xs) ys)), [y] ++ snd(fst(alignment (x:xs) ys))), 1 + snd(alignment (x:xs) ys))
 spc2 = (([x] ++ fst(fst(alignment xs (y:ys))), "-" ++ snd(fst(alignment xs (y:ys) ))), 1 + snd(alignment xs (y:ys) )) 
 in
 max'' [aln, spc1, spc2]
 | otherwise = let
 misaln = (([x] ++ fst(fst(alignment xs ys)), [y] ++ snd(fst(alignment xs ys))), 2 + snd(alignment xs ys))
 spc1 = (("-" ++ fst(fst(alignment (x:xs) ys)), [y] ++ snd(fst(alignment (x:xs) ys))), 1 + snd(alignment (x:xs) ys))
 spc2 = (([x] ++ fst(fst(alignment xs (y:ys))), "-" ++ snd(fst(alignment xs (y:ys) ))), 1 + snd(alignment xs (y:ys) )) 
 in
 max'' [misaln, spc1, spc2]

-- We will now pass a dictionary to remember previously calculated scores 
-- and return the updated dictionary along with the result. Use let 
-- expressions like the last part and pass the dictionary from each call
-- to the next. Also write logic to skip the entire calculation if the 
-- score is found in the dictionary. You need just one call to insert.
type ScoreDict = Dict (DNA,DNA) Int

scoreMemo :: (DNA,DNA) -> ScoreDict -> (ScoreDict,Int)
scoreMemo (x, y) (z:zs) = let
 lu = lookupDict (x, y) (z:zs)
 ans
  | lu == Nothing = ((insertDict (x,y) (score x y) (z:zs)), score x y)
  | otherwise = let
  abc =((z:zs), unboxTherapy(lu))
  in
  abc
 in 
 ans

-- In this part, we will use an alternate representation for the 
-- dictionary and rewrite the scoreMemo function using this new format.
-- The dictionary will be just the lookup function so the dictionary 
-- can be invoked as a function to lookup an element. To insert an
-- element you return a new function that checks for the inserted
-- element and returns the old dictionary otherwise. You will have to
-- think a bit on how this will work. An empty dictionary in this 
-- format is (\_->Nothing)

type Dict2 a b = a->Maybe b
insertDict2 :: (Eq a) => a -> b -> (Dict2 a b)-> (Dict2 a b)
insertDict2 = undefined
-- insertDict2 x y z 
--  | Dict2 x y == Nothing = Dict2 x y
--  | otherwise = z

type ScoreDict2 = Dict2 (DNA,DNA) Int

scoreMemo2 :: (DNA,DNA) -> ScoreDict2 -> (ScoreDict2,Int)
scoreMemo2 = undefined

-- ---------------------------------------------------------------------------
-- 				PART 5
-- ---------------------------------------------------------------------------

-- Now, we will try to find the mutationDistance between two DNA sequences.
-- You have to calculate the number of mutations it takes to convert one 
-- (start sequence) to (end sequence). You will also be given a bank of 
-- sequences. However, there are a couple of constraints, these are as follows:

-- 1) The DNA sequences are of length 8
-- 2) For a sequence to be a part of the mutation distance, it must contain 
-- "all but one" of the neuclotide bases as its preceding sequence in the same 
-- order AND be present in the bank of valid sequences
-- 'AATTGGCC' -> 'AATTGGCA' is valid only if 'AATTGGCA' is present in the bank
-- 3) Assume that the bank will contain valid sequences and the start sequence
-- may or may not be a part of the bank.
-- 4) Return -1 if a mutation is not possible


-- mutationDistance "AATTGGCC" "TTTTGGCA" ["AATTGGAC", "TTTTGGCA", "AAATGGCC", "TATTGGCC", "TTTTGGCC"] == 3
-- mutationDistance "AAAAAAAA" "AAAAAATT" ["AAAAAAAA", "AAAAAAAT", "AAAAAATT", "AAAAATTT"] == 2

find' :: DNA -> [DNA] -> Int
find' _ [] = 0
find' y (x:xs) 
 | y==x = 1
 | otherwise = find' y xs

findDist :: DNA -> DNA -> Int
findDist [] _ = 0
findDist (x:xs) (y:ys)
 | x /= y = 1 +findDist xs ys
 | otherwise = findDist xs ys

findOneUp' :: DNA -> [DNA] -> [DNA]
findOneUp' _ [] = []
findOneUp' x (y:ys) 
 | findDist x y == 1 = [y] ++ findOneUp' x ys
 | otherwise = findOneUp' x ys

findOneUp :: [DNA] -> [DNA] -> [DNA]
findOneUp [] _ = []
findOneUp (x:xs) (y:ys) = (findOneUp' x (y:ys)) ++ (findOneUp xs (y:ys))

reCURSE :: [DNA] -> DNA -> [DNA] -> Int -> Int
reCURSE [] _ _ _ = -1
reCURSE (x:xs) y (z:zs) n
 | n > length (z:zs) = -1
 | find' y (x:xs) == 1 = n
 | otherwise = let
 onelv = findOneUp (x:xs) (z:zs)
 in
 reCURSE (onelv) y (z:zs) (n+1)

mutationDistance :: DNA -> DNA -> [DNA] -> Int
mutationDistance x y z
 | find' y z == 0 = -1
 | otherwise = let
 r = (reCURSE [x] y z 0)
 in
 r

-- ---------------------------------------------------------------------------
-- 				PART 6
-- ---------------------------------------------------------------------------
--
-- Now, we will write a function to transcribe DNA to RNA. 
-- The difference between DNA and RNA is of just one base i.e.
-- instead of Thymine it contains Uracil. (U)
--
transcribeDNA :: DNA -> RNA
transcribeDNA [] = []
transcribeDNA (x:xs)
 | x == 'T' = ['U'] ++ transcribeDNA xs
 | otherwise = [x] ++ transcribeDNA xs


-- Next, we will translate RNA into proteins. A codon is a group of 3 neuclotides 
-- and forms an aminoacid. A protein is made up of various amino acids bonded 
-- together. Translation starts at a START codon and ends at a STOP codon. The most
-- common start codon is AUG and the three STOP codons are UAA, UAG and UGA.
-- makeAminoAcid should return Nothing in case of a STOP codon.
-- Your translateRNA function should return a list of proteins present in the input
-- sequence. 
-- Please note that the return type of translateRNA is [String], you should convert
-- the abstract type into a concrete one.
-- You might wanna use the RNA codon table from 
-- https://www.news-medical.net/life-sciences/RNA-Codons-and-DNA-Codons.aspx
-- 
--

codonTable = [("UUU", "Phe"), ("UCU", "Ser"), ("UAU", "Tyr"), ("UGU", "Cys"), ("UUC", "Phe"), ("UCC", "Ser"), ("UAC", "Tyr"), ("UGC", "Cys"), ("UUA", "Leu"), ("UCA", "Ser"), ("UAA", "STOP"), ("UGA", "STOP"), ("UUG", "Leu"), ("UCG", "Ser"), ("UAG", "STOP"), ("UGG", "Trp"), ("CUU", "Leu"), ("CCU", "Pro"), ("CAU", "His"), ("CGU", "Arg"), ("CUC", "Leu"), ("CCC", "Pro"), ("CAC", "His"), ("CGC", "Arg"), ("CUA", "Leu"), ("CCA", "Pro"), ("CAA", "Gln"), ("CGA", "Arg"), ("CUG", "Leu"), ("CCG", "Pro"), ("CAG", "Gln"), ("CGG", "Arg"), ("AUU", "Ile"), ("ACU", "Thr"), ("AAU", "Asn"), ("AGU", "Ser"), ("AUC", "Ile"), ("ACC", "Thr"), ("AAC", "Asn"), ("AGC", "Ser"), ("AUA", "Ile"), ("ACA", "Thr"), ("AAA", "Lys"), ("AGA", "Arg"), ("AUG", "START"), ("ACG", "Thr"), ("AAG", "Lys"), ("AGG", "Arg"), ("GUU", "Val"), ("GCU", "Ala"), ("GAU", "Asp"), ("GGU", "Gly"), ("GUC", "Val"), ("GCC", "Ala"), ("GAC", "Asp"), ("GGC", "Gly"), ("GUA", "Val"), ("GCA", "Ala"), ("GAA", "Glu"), ("GGA", "Gly"), ("GUG", "Val"), ("GCG", "Ala"), ("GAG", "Glu"), ("GGG", "Gly")]

makeAminoAcid :: Codon -> AminoAcid
makeAminoAcid x 
 |(lookupDict x codonTable) == Just "STOP" = Nothing
 |otherwise = lookupDict x codonTable

unboxTherapy:: Maybe a -> a
unboxTherapy (Just x) = x

translateRNA :: RNA -> [String] 
translateRNA [] = []
translateRNA (x:y:[]) = []
translateRNA (x:[]) = []
translateRNA (x:y:z:xs)
 | makeAminoAcid(([x] ++ [y]) ++ [z]) == Just "START" = [] ++ translateRNA' xs
 | otherwise = translateRNA (xs)

translateRNA' :: RNA -> [String]
translateRNA' [] = []
translateRNA' (x:y:[]) = []
translateRNA' (x:[]) = []
translateRNA' (x:y:z:xs)
 | lookupDict (([x] ++ [y]) ++ [z]) codonTable == Just "STOP" = []
 | makeAminoAcid(([x] ++ [y]) ++ [z]) == Nothing = [] ++ translateRNA' xs
 | otherwise = let
 mAA = makeAminoAcid(([x] ++ [y]) ++ [z])
 in
 [unboxTherapy (mAA)] ++ translateRNA' xs
