function esmtools_toggleContent(button) {
    var parentDiv = button.parentElement;
    var childNodes = parentDiv.childNodes;
    
    // Toggle the 'esmtools-btn-open' class on the parent div
    parentDiv.classList.toggle("esmtools-container-open");

    for (var i = 2; i < childNodes.length; i++) {
      var node = childNodes[i];
      // if (!node.classList.contains("content-container")){
          if (node.nodeType === Node.ELEMENT_NODE) {
              if (node.style.display === "none") {
                  node.style.display = "block";
                  console.log("ok")
              } else {
                  node.style.display = "none";
              }
          }
      // }
    }
}