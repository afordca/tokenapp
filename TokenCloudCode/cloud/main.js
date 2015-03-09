
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("userName", function(request,response){

	var query = new Parse.Query(Parse.User);
	query.equalTo("username", request.params.username);
	query.first({
		success: function(object) {
			var userString = request.object.get("username");
			response.success(userString);
		},
		error: function(error) {
			alert("Error: " + error.code + " " + error.message);
		}
		});
	});

Parse.Cloud.define("personalActivity", function(request,response){

	var query = new Parse.Query("Activity");
	query equalTo("username", request.params.username);
	query.find({
		var 

	})

