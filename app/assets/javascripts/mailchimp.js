$(document).ready(function(){

  $('form#mailchimp')
    .bind("ajax:beforeSend", function(evt, xhr, settings){
      var $divResponse = $('div#response');

      // Update the text of the submit button to let the user know stuff is happening.
      // But first, store the original text of the submit button, so it can be restored when the request is finished.
      $divResponse.data( 'origText', $divResponse.text() );
      $divResponse.text( "Adding Email...." );

    })
    .bind("ajax:success", function(evt, data, status, xhr){
      var $form = $(this);
       var $divResponse = $('div#response');

      // Reset fields and any validation errors, so form can be used again, but leave hidden_field values intact.
      $form.find('input[type="email"]').val("");
      $divResponse.html(data.message);
    })
    .bind('ajax:complete', function(evt, xhr, status){
      var $divResponse = $('div#response');
    })
    .bind("ajax:error", function(evt, xhr, status, error){
       var $divResponse = $('div#response'),
          errors,
          errorText,
      errorList;

      try {
        // Populate errorText with the comment errors
        errors = $.parseJSON(xhr.responseText);
      } catch(err) {
        // If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
        errors = {message: "Please reload the page and try again"};
      }

      // Build an unordered list from the list of errors
      errorText = "There were errors with the submission. Please reload the page and try again.";
      errorList = "<ul>"
      for ( error in errors ) {
        errorList += "<li>" + error + ': ' + errors[error] + "</li> ";
      }

      errorList += "</ul>";

      // Insert error list into form
      $divResponse.html(errorText);
    });

});