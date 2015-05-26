function validateResetPasswordForm() {
  jQuery.validator.addMethod("password_format", function(value, element) {
    return /(?=.*?[A-Z])(?=.*?[a-z])(?=.+[0-9])(?=.*?[!@$#&*_\.,;:])/.test( value );
  });
  jQuery.validator.addMethod("pswd_match",function (value,element){
    return $("#inp_password").val() == $('#inp_password_confirmation').val();
  });
  $('#reset_password_form').validate({
    debug: true,
    rules: {
      "user[password]": {
        required: true,
        password_format: true,
        minlength: 2,
        maxlength: 50
      },
      "user[password_confirmation]": {
        required: true,
        pswd_match: true,
      }
    },
    errorElement: "span",
    errorClass: "help-block",
    messages: {
      "user[password]": {
        required: "Password can't be blank.",
        password_format: "Password should have atleast one uppercase, one lowercase, 1 number and 1 special character.",
        maxlength: "Number of characters must be 2 to 50."
      },
      "user[password_confirmation]": {
        required: "Password confirmation can't be blank.",
        pswd_match: "Doesn't match with the password."
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
$("#div_reset_password_js_validation_error").remove();
errorHtml = "<div id='div_reset_password_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
$("#div_modal_generic div.modal-body-main").prepend(errorHtml);
// Show error labels
$("div.error").show();
} else {
// Hide error labels
$("div.error").hide();
// Removing the error message
$("#div_reset_password_js_validation_error").remove();
}
},
submitHandler: function(form) {
  form.submit();
}
});
}