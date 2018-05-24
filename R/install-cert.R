#' Helper to install mitmproxy root CA certificate
#' 
#' This won't install the certificate in Firefox. You will need to do that manually.
#' 
#' @md
#' @export
install_mitm_certificate <- function() {
  
  mitm_path <- path.expand("~/.mitmproxy")
  mitm_ca_fil <- file.path(mitm_path, "mitmproxy-ca.pem")
  
  if (!file.exists(mitm_ca_fil)) {
    stop("mitmproxy certificates have not been generated yet. Please see the 'Getting Started' vignette: `vignette(\"getting-started\", package=\"middlechild\")`.", call.=FALSE)
  }
  
  if (is_windows()) {
    message("NOT YET")
  } else if (is_linux()) {
    message("NOT YET")
  } else { # hopefully macOS
    pass <- getPass::getPass("macOS Password: ")
    suppressWarnings(
      system(
        sprintf(
          "echo %s | sudo -S security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.mitmproxy/mitmproxy-ca-cert.pem", 
          shQuote(pass)
        ), intern = TRUE, ignore.stderr = TRUE
      )
    )-> res
  }
  
}