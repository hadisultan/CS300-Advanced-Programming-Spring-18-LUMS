package main

import (
	"os"
	"fmt"
    "reflect"
	"encoding/binary"
)

func lookup(codes []int, palette [][3]uint8) []uint8 {
    // fmt.Println("WARNING: Please copy sequential lookup code from Part1 here")
    codesize := len(codes)
    td := make([]uint8,(len(codes)*3))
    for i := 0; i < codesize; i++ {
        temparr := palette[codes[i]]
        td[(i*3)+2] = temparr[0]
        td[(i*3)+1] = temparr[1]        
        td[(i*3)] = temparr[2]
    }
    return td
}

func decompress(codes []int, dict [][]int) []int {
    // fmt.Println("WARNING: Please copy sequential decompress code from Part3 here")
	dictlen := 0
    for i:= 0; i<len(dict); i++ {
        dictlen = dictlen + len(dict[i])
    }
    td := make([]int,dictlen)
    codesize := len(codes)
    pointer := 0
    for i := 0; i < codesize; i++ {
        temparr := dict[codes[i]]
        varlen := len(temparr)
        for j := 0; j < varlen; j++ {
            td[pointer] = temparr[j]
            pointer = pointer + 1
        }
    }
    
    return td
}

func dictionary(codes []int) [][]int {
    var td [][] int
    td = make([][]int,256)
    for i:= 0; i< 256; i++ {
        td[i] = make([]int, 1)
        td[i][0] = i
    }

    td = append(td, []int{})
    td = append(td, []int{})
    pointer := 258
    codesize := len(codes)
    for i:=2; i<codesize; i++ {
        code := codes[i]
        prev := codes[i-1]
        prevdict := td[prev]
        if(code>=len(td)){
            prevdict = append(prevdict, prevdict[0])
        } else {
            prevdict = append(prevdict, td[code][0])
        }
        td = append(td, []int{})
        td[pointer] = prevdict
        pointer = pointer + 1
    }

    // fmt.Println(td)

    return td
}

/* Part 7: Generate the GIF codes from coded data
In this part, you are given a list of encoded data from which you have to figure out the GIF codes. ALL GIF codes for this part are 9-bit codes. The least significant 8 bits of the first code are in the first byte and the most significant one bit is in the least significant position of the second byte. The least significant 7 bits of the second code are in the remaining bits of the second byte, and the most significant two bits are in the least significant positions of the third byte and so on. GIF code that is exactly 0x101 (257) means end of input and this code must NOT be included in the output. All inputs will be valid.

Here is a primer on bit operations:
    x >> y shifts the bits of x right by y bits (and << shifts left)
    x & y keeps the bits that are turned on in BOTH
    x | y keeps the bits that are turned on in any of the two
    you can cast between unsigned and signed types like this: uint(x) or int(y)
*/
func decode(bitstream []uint8) []int {
	return []int{}
}

/* Part 8: Parallel decoding of GIF codes
In this part, you will divide the work in two halves (not recursively) with the right half working on half the coded data. You can either make helper functions or use lambda functions. You are to be careful about the boundary because the first byte of the right half will likely start from somewhere in the middle of the byte. Since you know each code is 9-bits, you can easily calculate the starting bit using the number of bytes on the left side. 

Once you finish the task, the given main function will produce "out7.bmp" which has the password for Part 9 
*/
func parallel_decode(data []uint8) []int {
    return []int{}
}

func main() {
    data, palette, dimX, dimY := gif("part7.gif")
    gif_codes := decode(data)
    bmp("out7.bmp", lookup(decompress(gif_codes, dictionary(gif_codes)), palette), dimX, dimY)

    if !reflect.DeepEqual(parallel_decode(data), gif_codes) {
        fmt.Println("Parallel decoding differs from sequential decoding")
    }
    fmt.Println("Done")
}

// DO NOT WORRY ABOUT ANYTHING BELOW THIS LINE

func bmp(filename string, data []uint8, dimX, dimY uint16) {
    bmp, _ := os.Create(filename)
    defer bmp.Close()
    binary.Write(bmp, binary.LittleEndian, []byte{'B','M'})
    binary.Write(bmp, binary.LittleEndian, []int32{int32(54+len(data)), 0, 54, 40, int32(dimX), -1 * int32(dimY), 0x180001, 0, 0, 0, 0, 0, 0})
    binary.Write(bmp, binary.LittleEndian, data)
}

func gif(filename string) ([]uint8, [][3]uint8, uint16, uint16) {
	gif, _ := os.Open(filename)
	defer gif.Close()
    gif.Seek(6, 1)
    var dimX, dimY uint16
    binary.Read(gif, binary.LittleEndian, &dimX)
    binary.Read(gif, binary.LittleEndian, &dimY)
    var flags uint8
    binary.Read(gif, binary.LittleEndian, &flags)
    palette := make([][3]uint8, 256)
    gif.Seek(2, 1)
    if flags & 0x80 == 0x80 {
        binary.Read(gif, binary.LittleEndian, palette)
    }
	var block_type uint8
	for block_type != 0x2C {
        binary.Read(gif, binary.LittleEndian, &block_type);
        if block_type == 0x21 {
			gif.Seek(1, 1)
            var length uint8
            binary.Read(gif, binary.LittleEndian, &length)
			gif.Seek(int64(length), 1)
        }
    }
    gif.Seek(9, 1)
    if flags & 0x80 == 0 {
        binary.Read(gif, binary.LittleEndian, palette)
    }
    gif.Seek(1, 1)
	var sub_block_size uint8
    binary.Read(gif, binary.LittleEndian, &sub_block_size)
    data := []uint8{}
	for sub_block_size != 0 {
        compressed_data := make([]uint8, sub_block_size)
		binary.Read(gif, binary.LittleEndian, compressed_data)
        data = append(data, compressed_data...)
        binary.Read(gif, binary.LittleEndian, &sub_block_size)
    }
    data = append(data, 0)
    return data, palette, dimX, dimY
}

