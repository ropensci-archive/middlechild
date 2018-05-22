#' Helper to get mitmproxy installed
#' 
#' It doesn't so much as "install" anything as guide you on the path.
#' 
#' @md
#' @family mitm_helpers
#' @export
install_mitm <- function() {
  
  message(
    "Please see <https://docs.mitmproxy.org/stable/overview-installation/> ",
    "for the latest, official installation documentation."
  )
  
  if (is_windows()) {
    
    "You can use the following link to download the mitmproxy binary"
    
  } else if (is_linux()) {
    
    message(
      "You can install mitmproxy on Linux via pip3. This requires a working ",
      "Python 3.6+ environment. Here are posssible installation instructions ", 
      "For various Linux package managers:\n\n",
      "  sudo apt install python3-pip # Debian 10 | Ubuntu 17.10 or higher\n",
      "  sudo dnf install python3-pip # Fedora 26 or higher\n",
      "  sudo pacman -S python-pip # Arch Linux\n\n",
      "Ensure you're running the latest pip3:\n\n",
      "  sudo pip3 install -U pip\n\n",
      "Install via pip3:\n\n",
      "  sudo pip3 install mitmproxy"
    )
    
  } else { # macOS (hopefully)
    message("\n Please run 'brew install mitmproxy' at a macOS command prompt.")
  }
  
  message(
    "\n The path to the executable 'mitmdump[.exe]' must be available on the system PATH."
  )
  
}