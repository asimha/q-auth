function validateUserForm() {

    $('#form_user').validate({
      debug: true,
      rules: {
        "user[name]": {
            required: true,
            minlength: 2,
            maxlength: 50
        },
        "user[username]": {
            required: true,
            minlength: 2,
            maxlength: 50
        },
        "user[email]": {
            required: true,
            email: true
        },
        "user[designation_id]": "required",
      },
      errorElement: "span",
      errorClass: "help-block",
      messages: {
        "user[first_name]": "can't be blank",
        "user[last_name]": "can't be blank",
        "user[username]": "can't be blank",
        "user[email]": {
            required: "We need your email address to contact you",
            email: "Your email address must be in the format of name@domain.com"
        }
      },
      highlight: function(element) {
          $(element).parent().parent().addClass("has-error");
      },
      unhighlight: function(element) {
          $(element).parent().parent().removeClass("has-error");
      },
      invalidHandler: function(event, validator) {
        // 'this' refers to the form
        var errors = validator.numberOfInvalids();
        if (errors) {

          // Populating error message
          var errorMessage = errors == 1
            ? 'You missed 1 field. It has been highlighted'
            : 'You missed ' + errors + ' fields. They have been highlighted';

          // Removing the form error if it already exists
          var errorHtml = "<div class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          $("#user_form_error").html(errorHtml);

          // Show error labels
          $("div.error").show();

        } else {
          // Hide error labels
          $("div.error").hide();

          // Removing the error message
          $("#user_form_error").remove();
        }
      }

    });

}
