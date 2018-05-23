check_certs <- function() {
  
  mp <- find_mitm()
  if (mp == "") return("mitmproxy not found. Please run install_mitm().")
  
  mitm_path <- path.expand("~/.mitmproxy")
  mitm_ca_fil <- file.path(mitm_path, "mitmproxy-ca.pem")
  
  if (!file.exists(mitm_ca_fil)) {
    return("mitmproxy certificates have not been generated yet. Please see the 'Getting Started' vignette.")
  }
  
  if (is_windows()) {
    message("TODO")
    return("OK")
  } else if (is_linux()) {
    message("TODO")
    return("OK")
  } else {
   verify <- system("security verify-cert -c ~/.mitmproxy/mitmproxy-ca-cert.cer", intern=TRUE)
   if (grepl("success", verify)) return("OK")
   return(sprintf("%s\n", "Certificates not trusted. Please see the 'Getting Started' vignette."))
  }
  
}

.onLoad <- function(libname, pkgname) {
  
  if (interactive()) {
    
    res <- check_certs()
    
    if (res == "OK") return()
    
    packageStartupMessage(res)

  }
  
}


