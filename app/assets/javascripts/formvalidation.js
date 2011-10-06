// Append the function to the "document ready" chain
jQuery(function($) {
  // when the #search field changes
  $("#selectedExportFormat").change(function() {
    var str=$("#selectedExportFormat option:selected").text();
    if (str != "PNG" && str!="TXT" && str!="TIF") {
      alert("You are trying to export am image with a bit depth of more than 8 bit. The selected file format does not support this. You might loose information!! Possible formats are 'PNG', 'TIF' and 'TXT'");
    }
  });
})
