package main

import (
    "fmt"
    "os"
    "strconv"
    "math"
	"encoding/csv"
    "sync"
)

type CensusGroup struct {
	population int
	latitude, longitude float64
}


func ParseCensusData(fname string) ([]CensusGroup, error) {
	file, err := os.Open(fname)
    if err != nil {
		return nil, err
    }
    defer file.Close()

	records, err := csv.NewReader(file).ReadAll()
	if err != nil {
		return nil, err
	}
	censusData := make([]CensusGroup, 0, len(records))

    for _, rec := range records {
        if len(rec) == 7 {
            population, err1 := strconv.Atoi(rec[4])
            latitude, err2 := strconv.ParseFloat(rec[5], 64)
            longitude, err3 := strconv.ParseFloat(rec[6], 64)
            if err1 == nil && err2 == nil && err3 == nil {
                latpi := latitude * math.Pi / 180
                latitude = math.Log(math.Tan(latpi) + 1 / math.Cos(latpi))
                censusData = append(censusData, CensusGroup{population, latitude, longitude})
            }
        }
    }

	return censusData, nil
}

func p1(gibbu [] CensusGroup) (float64, float64, float64, float64) {
    latitudemin := gibbu[0].latitude
    latitudemax := gibbu[0].latitude
    longitudemin := gibbu[0].longitude
    longitudemax := gibbu[0].longitude
    for i:=1; i<len(gibbu); i++ {
        if gibbu[i].latitude > latitudemax {
            latitudemax = gibbu[i].latitude
        }
        if gibbu[i].latitude < latitudemin {
            latitudemin = gibbu[i].latitude
        }
        if gibbu[i].longitude > longitudemax {
            longitudemax = gibbu[i].longitude
        }
        if gibbu[i].longitude < longitudemin {
            longitudemin = gibbu[i].longitude
        }
    }
    return latitudemax, latitudemin, longitudemin, longitudemax
}

func p2(gibbu [] CensusGroup) (float64, float64, float64, float64) {
    var latmax, latmin, longmin, longmax float64
    if len(gibbu)<=10 {
       latmax, latmin, longmin, longmax = p1(gibbu)
    } else {
        var latmax1, latmin1, longmin1, longmax1 float64
        var latmax2, latmin2, longmin2, longmax2 float64
        mid := len(gibbu)/2
        done := make(chan bool)
        go func() {
            latmax1, latmin1, longmin1, longmax1 = p2(gibbu[:mid])
            done<-true
        }()
        go func(){
            latmax2, latmin2, longmin2, longmax2 = p2(gibbu[mid:])
            done<-true
        }()
        <-done
        <-done
        latmax = math.Max(latmax1, latmax2)
        latmin = math.Min(latmin1, latmin2)
        longmin = math.Min(longmin1, longmin2)
        longmax = math.Max(longmax1, longmax2)
    }
    return latmax, latmin, longmin, longmax
}

func p4(gibbu [] CensusGroup, td [][]int, latmax float64, latmin float64, longmin float64, longmax float64, xdim int, ydim int, xwidth float64, ywidth float64) ([][]int) {
    var ntd1 [][] int
    ntd1 = make([][] int, xdim)
    for i := range ntd1 {
        ntd1[i] = make([]int, ydim)
    }
    for i := 0; i < xdim; i++ {
        for j := 0; j < ydim; j++ {
            ntd1[i][j] = 0
        }
    }
    var ntd2 [][] int
    ntd2 = make([][] int, xdim)
    for i := range ntd2 {
        ntd2[i] = make([]int, ydim)
    }
    for i := 0; i < xdim; i++ {
        for j := 0; j < ydim; j++ {
            ntd2[i][j] = 0
        }
    }
    if len(gibbu)<=10 {
        for i := 0; i < len(gibbu); i++ {
            xi := int(math.Floor((gibbu[i].longitude - longmin)/(xwidth)))
            yi := int(math.Floor((gibbu[i].latitude - latmin)/(ywidth)))
            if yi == ydim {
                yi--
            }
            if xi == xdim {
                xi--
            }
            ntd1[xi][yi] = ntd1[xi][yi] + gibbu[i].population
        }
        return ntd1
    } else {
        mid := len(gibbu)/2
        done := make(chan bool)
        go func(){
            ntd1 = p4(gibbu[:mid], td, latmax, latmin, longmin, longmax, xdim, ydim, xwidth, ywidth)
            done<-true
        }()
        go func(){
            ntd2 = p4(gibbu[mid:], td, latmax, latmin, longmin, longmax, xdim, ydim, xwidth, ywidth)
            done<-true

        }()
        <-done
        <-done
        for i := 0; i < xdim; i++ {
            for j := 0; j < ydim; j++ {
                ntd1[i][j] = ntd1[i][j] + ntd2[i][j]
            }
        }
        return ntd1
    }
}

var mu5 [][] sync.Mutex

func p5(gibbu [] CensusGroup, td [][]int, latmax float64, latmin float64, longmin float64, longmax float64, xdim int, ydim int, xwidth float64, ywidth float64) {
    if len(gibbu)<=10 {
        for i := 0; i < len(gibbu); i++ {
            xi := int(math.Floor((gibbu[i].longitude - longmin)/(xwidth)))
            yi := int(math.Floor((gibbu[i].latitude - latmin)/(ywidth)))
            if yi == ydim {
                yi--
            }
            if xi == xdim {
                xi--
            }
            mu5[xi][yi].Lock()
            td[xi][yi] = td[xi][yi] + gibbu[i].population
            mu5[xi][yi].Unlock()
        }
    } else {
        mid := len(gibbu)/2
        done := make(chan bool)
        go func(){
            // mu.Lock()
            p5(gibbu[:mid], td, latmax, latmin, longmin, longmax, xdim, ydim, xwidth, ywidth)
            // mu.Unlock()
            done<-true
        }()
        go func(){
            // mu.Lock()
            p5(gibbu[mid:], td, latmax, latmin, longmin, longmax, xdim, ydim, xwidth, ywidth)
            // mu.Unlock()
            done<-true

        }()
        <-done
        <-done
    }
}

func getwidth(latmax float64, latmin float64, longmax float64, longmin float64, x int, y int) (float64, float64) {
    xw := (longmax-longmin)/float64(x)
    yw := (latmax-latmin)/float64(y)
    return xw, yw    
}

func p2postquery(gibbu [] CensusGroup, west int, south int, east int, north int, longmin float64, latmin float64, xwidth float64, ywidth float64) (int, int) {
    if len(gibbu)<=10 {
        total := 0
        inplace := 0
        for i:=0; i<len(gibbu); i++{
            xplace := int(math.Ceil((gibbu[i].longitude-longmin)/(xwidth)))
            yplace := int(math.Ceil((gibbu[i].latitude-latmin)/(ywidth)))
            if(xplace == 0){
                    xplace = xplace + 1
                }
            if(yplace == 0){
                yplace = yplace + 1
            }
            if(xplace>=west && xplace<= east && yplace>=south && yplace<=north){
                inplace = inplace + gibbu[i].population
            }
            total = total + gibbu[i].population
        }
        return inplace, total
    } else {
        mid := len(gibbu)/2
        done := make(chan bool)
        var pop1, pop2 int
        var tot1, tot2 int
        go func() {
            pop1, tot1 = p2postquery(gibbu[:mid], west, south, east, north, longmin, latmin, xwidth, ywidth)
            done<-true
        }()
        go func() {
            pop2, tot2 = p2postquery(gibbu[mid:], west, south, east, north, longmin, latmin, xwidth, ywidth)
            done<-true
        }()
        <-done
        <-done
        return pop1+pop2, tot1+tot2
    }
}

func main () {
	if len(os.Args) < 4 {
		fmt.Printf("Usage:\nArg 1: file name for input data\nArg 2: number of x-dim buckets\nArg 3: number of y-dim buckets\nArg 4: -v1, -v2, -v3, -v4, -v5, or -v6\n")
		return
	}
	fname, ver := os.Args[1], os.Args[4]
    xdim, err := strconv.Atoi(os.Args[2])
	if err != nil {
		fmt.Println(err)
		return
	}
    ydim, err := strconv.Atoi(os.Args[3])
	if err != nil {
		fmt.Println(err)
		return
	}
	censusData, err := ParseCensusData(fname)
	if err != nil {
		fmt.Println(err)
		return
	}
    var latmax, latmin, longmin, longmax, xwidth, ywidth float64
    var td [][] int

    // Some parts may need no setup code
    switch ver {
    case "-v1":
        // YOUR SETUP CODE FOR PART 1
        latmax, latmin, longmin, longmax = p1(censusData)
        xwidth, ywidth = getwidth(latmax, latmin, longmax, longmin, xdim, ydim)
    case "-v2":
        // YOUR SETUP CODE FOR PART 2
        latmax, latmin, longmin, longmax = p2(censusData)
        xwidth, ywidth = getwidth(latmax, latmin, longmax, longmin, xdim, ydim)
    case "-v3":
        // YOUR SETUP CODE FOR PART 3
        latmax, latmin, longmin, longmax = p2(censusData)
        xwidth, ywidth = getwidth(latmax, latmin, longmax, longmin, xdim, ydim)
        td = make([][] int, xdim)
        for i := range td {
            td[i] = make([]int, ydim)
        }
        for i := 0; i < xdim; i++ {
            for j := 0; j < ydim; j++ {
                td[i][j] = 0
            }
        }
        for i := 0; i < len(censusData); i++ {
            xi := int(math.Floor((censusData[i].longitude - longmin)/(xwidth)))
            yi := int(math.Floor((censusData[i].latitude - latmin)/(ywidth)))
            if yi == ydim {
                yi--
            }
            if xi == xdim {
                xi--
            }

            td[xi][yi] = td[xi][yi] + censusData[i].population
        }
        for i := 0; i < xdim; i++ {
            for j := 0; j < ydim; j++ {
                left:= 0
                up:=0
                diag:=0
                if j>0{
                    left = td[i][j-1]
                }
                if i>0{
                    up = td[i-1][j]
                }
                if i>0 && j>0 {
                    diag = td[i-1][j-1]
                }
                td[i][j] = td[i][j] + up + left - diag
            }
        }
    case "-v4":
        // YOUR SETUP CODE FOR PART 4
        latmax, latmin, longmin, longmax = p2(censusData)
        xwidth, ywidth = getwidth(latmax, latmin, longmax, longmin, xdim, ydim)
        td = make([][] int, xdim)
        for i := range td {
            td[i] = make([]int, ydim)
        }
        for i := 0; i < xdim; i++ {
            for j := 0; j < ydim; j++ {
                td[i][j] = 0
            }
        }
        td = p4(censusData, td, latmax, latmin, longmin, longmax, xdim, ydim, xwidth, ywidth)
        for i := 0; i < xdim; i++ {
            for j := 0; j < ydim; j++ {
                left:= 0
                up:=0
                diag:=0
                if j>0{
                    left = td[i][j-1]
                }
                if i>0{
                    up = td[i-1][j]
                }
                if i>0 && j>0 {
                    diag = td[i-1][j-1]
                }
                td[i][j] = td[i][j] + up + left - diag
            }
        }


    case "-v5":
        // YOUR SETUP CODE FOR PART 5
        mu5 = make([][] sync.Mutex, xdim)
        for i := range mu5 {
            mu5[i] = make([]sync.Mutex, ydim)
        }
        latmax, latmin, longmin, longmax = p2(censusData)
        xwidth, ywidth = getwidth(latmax, latmin, longmax, longmin, xdim, ydim)
        td = make([][] int, xdim)
        for i := range td {
            td[i] = make([]int, ydim)
        }
        for i := 0; i < xdim; i++ {
            for j := 0; j < ydim; j++ {
                td[i][j] = 0
            }
        }
        p5(censusData, td, latmax, latmin, longmin, longmax, xdim, ydim, xwidth, ywidth)
        for i := 0; i < xdim; i++ {
            for j := 0; j < ydim; j++ {
                left:= 0
                up:=0
                diag:=0
                if j>0{
                    left = td[i][j-1]
                }
                if i>0{
                    up = td[i-1][j]
                }
                if i>0 && j>0 {
                    diag = td[i-1][j-1]
                }
                td[i][j] = td[i][j] + up + left - diag
            }
        }

    case "-v6":
        // YOUR SETUP CODE FOR PART 6
    default:
        fmt.Println("Invalid version argument")
        return
    }

    for {
        var west, south, east, north int
        n, err := fmt.Scanln(&west, &south, &east, &north)
        if n != 4 || err != nil || west<1 || west>xdim || south<1 || south>ydim || east<west || east>xdim || north<south || north>ydim {
            break
        }

        var population int
        var percentage float64
        switch ver {
        case "-v1":
            // YOUR QUERY CODE FOR PART 1
            total := 0
            inplace := 0
            for i:=0; i<len(censusData); i++{
                xplace := int(math.Ceil((censusData[i].longitude-longmin)/(xwidth)))
                yplace := int(math.Ceil((censusData[i].latitude-latmin)/(ywidth)))
                if(xplace == 0){
                    xplace = xplace + 1
                }
                if(yplace == 0){
                    yplace = yplace + 1
                }
                if(xplace>=west && xplace<= east && yplace>=south && yplace<=north){
                    inplace = inplace + censusData[i].population
                }
                total = total + censusData[i].population
            }
            population = inplace
            percentage = (float64(inplace)/float64(total))*100
        case "-v2":
            // YOUR QUERY CODE FOR PART 2
            var tot, pop int
            pop, tot = p2postquery(censusData ,west, south, east, north, longmin, latmin, xwidth, ywidth)
            percentage = (float64(pop)/float64(tot))*100   
            population = pop       
        case "-v3":
            // YOUR QUERY CODE FOR PART 3
            west--
            east--
            south--
            north--
            up:=0
            left:=0
            diag:=0
            if(south>0){
                up = td[east][south-1]
            }
            if(west>0){
                left = td[west-1][north]
            }
            if(west>0 && south>0){
                diag = td[west-1][south-1]
            }
            tot:= td[xdim-1][ydim-1]
            population = td[east][north] - left - up + diag
            percentage = float64(population)/float64(tot)*100.0
        case "-v4":
            // YOUR QUERY CODE FOR PART 4
            west--
            east--
            south--
            north--
            up:=0
            left:=0
            diag:=0
            if(south>0){
                up = td[east][south-1]
            }
            if(west>0){
                left = td[west-1][north]
            }
            if(west>0 && south>0){
                diag = td[west-1][south-1]
            }
            tot:= td[xdim-1][ydim-1]
            population = td[east][north] - left - up + diag
            percentage = float64(population)/float64(tot)*100.0
        case "-v5":
            // YOUR QUERY CODE FOR PART 5
            west--
            east--
            south--
            north--
            up:=0
            left:=0
            diag:=0
            if(south>0){
                up = td[east][south-1]
            }
            if(west>0){
                left = td[west-1][north]
            }
            if(west>0 && south>0){
                diag = td[west-1][south-1]
            }
            tot:= td[xdim-1][ydim-1]
            population = td[east][north] - left - up + diag
            percentage = float64(population)/float64(tot)*100.0
        case "-v6":
            // YOUR QUERY CODE FOR PART 6
        }

        fmt.Printf("%v %.2f%%\n", population, percentage)
    }
}
