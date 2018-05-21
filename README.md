# MITM proxy in R 
  
[![Travis build status](https://travis-ci.org/ropenscilabs/middlechild.svg?branch=master)](https://travis-ci.org/ropenscilabs/middlechild)


This package provides a wrapper to [MITM proxy](https://mitmproxy.org/) from R and is designed to test R packages that make API calls. 


### Installation

```r
devtools::install_github("ropenscilabs/middlechild")
```

### Usage

```r
list_interfaces()

 hw_port            dev     mac              
  <chr>              <chr>   <chr>            
1 Wi-Fi              en0     ----------------
2 Bluetooth PAN      en7     ----------------
3 Thunderbolt 1      en3     ----------------
4 Thunderbolt 2      en8     ----------------
5 Thunderbolt 3      en4     ----------------
6 Thunderbolt 4      en9     ----------------
7 Thunderbolt Bridge bridge0 ----------------
```