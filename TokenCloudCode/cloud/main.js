Parse.Cloud.afterSave("Activity", function(request) {

    //Problem: Notifications system
    //Solution: Create notifications then create notifications object  
    var Notifications = Parse.object.extend("Notifications");
    var toUser = request.object.get("toUser'"); 
    var notifications = new NotificationsClass();
    notifications.set("toUser", toUser); 
    notifications.set("activity", request.object); 
    notifications.set("type", request.object.get("type"));
    notifications.set("isDelivered", false);

    notifications.save();
});

//Need the notifications for the toUser. Request param is for the toUser 


Parse.Cloud.define("UserNotification", function(request, response){
    var Notifications = Parse.object.extend("Notifications");
    var User = Parse.object.extend("User");
    var user = new User();
    user.id = request.params.toUser.id;
    var queryNotification = new Parse.Query(Notifications);
        queryNotification.equalTo("toUser", user);
            queryNotification.equalTo("isDelivered", false);
                queryNotification.find({
                    success: function(notifications){
                        for (var notification in notificatons){
                            notification.set("isDelivered", true);
                            notification.save();
                        }
                        response.success(notifications);
                    },
                    error: function(error){
                        response.error(error);
                    }
                });
});


    //We want the from user 


Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
 
Parse.Cloud.define("userName", function(request,response){
    var query = new Parse.Query(Parse.User);
    query.equalTo("username", request.params.username);
        query.first({
                success: function(object) {
                    var userString = request.params.username;
                    response.success(userString);
                },
                error: function(error) {
                    alert("Error: " + error.code + " " + error.message);
                }
            });
    });
 
Parse.Cloud.define("Activity", function(request, response){
    var Activity = Parse.Object.extend("Activity"); //An array in Javascript of Parse objects 
    var User = Parse.Object.extend("User");
    var user = new User(); 
    user.id = request.params.fromUser;
    var queryActivity = new Parse.Query(Activity);
        queryActivity.equalTo("fromUser", user);
                    queryActivity.find({
                        success: function(activities){
                            response.success(activities);
                      },
                      error: function(error) {
                          response.error(error);
                      }
            });
});

// Parse.Cloud.define("Activity", function(request, response){
//     var Activity = Parse.Object.extend("Activity"); //An array in Javascript of Parse objects 
//     var User = Parse.Object.extend("User");
//     var user = new User(); 
//     user.id = request.params.fromUser;
//     var queryActivity = new Parse.Query(Activity);
//         queryActivity.equalTo("fromUser", user);
//                     queryActivity.find({
//                         success: function(activities){
//                             response.success(activities);
//                       },
//                       error: function(error) {
//                           response.error(error);
//                       }
//             });



//Get the users the client is following 
//The users the cliesnt is following are stored in the user object in a PFrelation wtih their user object id
//once I get that that user, I get their list of activities 

Parse.Cloud.define("FollowingUsersActivities", function(request, response){
    var Activity = Parse.Object.extend("Activity");
    var User = Parse.Object.extend("User");
    var queryUser = new Parse.Query(User);
    queryUser.equalTo("objectId", request.params.currentUserId);
    var following = [];
    var followingUsersActivities = {};
    var actproplist = [];
    queryUser.first({
        success: function(user){
            var relation = user.relation("Following");
            var query = relation.query();
            query.find({
                success: function(followingResult){
                    var queries = [];
                //following = followingResult;
                 for (var x = 0; followingResult.length > x; x++){ 
                    var followingUser = followingResult[x];
                    //response.success(followingUser);
                    var queryActivity = new Parse.Query(Activity);
                    var actprop = [];
                    actprop.push(followingUser.get("Type"));
                    actprop.push(followingUser.id);
                    actproplist.push(actprop);
                    //var user = new User();
                    //user.id = followingUser.id; 
                    //initializes the key value pail
                    queryActivity.equalTo("fromUser", followingUser);
                    queries.push(queryActivity);
                      //response.success(followingUsersActivities);
                      //response.success(followingResult[0]);
                  }
                var totalLength = followingResult.length;
                function makeQueries(queryActivity) {
                    queryActivity.shift().find({
                            success: function(activities){
                                //response.success(activities);
                                followingUsersActivities[followingUser.id] = []; 
                                followingUsersActivities[followingUser.id] = activities; 
                                if(queryActivity.length){
                                    makeQueries(queryActivity);
                                } else {
                                    response.success(followingUsersActivities);
                                }
                            },
                            error: function(error) {
                                response.error(error);
                            }
                        });
                      
                }
                makeQueries(queries);
                //response.success(followingUsersActivities);
             },
             error: function(error) {
                response.error(error);
             }
            });
        },
             error: function(error) {
                response.error(error);
             }
    });
   
    // This creates a new JSON object --> {}; 

});

Parse.Cloud.define("Followers", function(request, response){
    var User = Parse.Object.extend("User");
    var queryUser = new Parse.Query(User);
    queryUser.equalTo("objectId", request.params.objectId);
    var followersArray = []; 
    var followersJSON = {};
   queryUser.first({
        success: function(user){
            var relation = user.relation("Followers");
            var query = relation.query();
             query.find({
             	success: function(followersResult){
             		for(var x = 0; followersResult.length > x; x++){
                 		var followers = followersResult[x];
                 		followersArray.push(followers);
                 	// console.log(followers);

                 }
                 	//followers = followersJSON;
            		response.success(followersArray);
             	}

            });
        	
        },
     	error: function(error){
        	response.error(error);
        }
	});
});

Parse.Cloud.define("Following", function(request, response){
	var User = Parse.Object.extend("User");
    var queryUser = new Parse.Query(User);
    queryUser.equalTo("objectId", request.params.objectId);
    var followingArray = []; 
    var followingJSON = {};
    queryUser.first({
        success: function(user){
            var relation = user.relation("Following");
            var query = relation.query();
             query.find({
             	success: function(followingResult){
             		for(var x = 0; followingResult.length > x; x++){
                 		var following = followingResult[x];
                 		followingArray.push(following);
                 	// console.log(followers);

                 }
                 	//followers = followersJSON;
            		response.success(followingArray);
             	}

            });
        	
        },
     	error: function(error){
        	response.error(error);
        }
	});
});

Parse.Cloud.define("Photo", function(request, response)
{
	var Photo = Parse.Object.extend("Photo");
	//var User = Parse.Object.extend("User");
	var queryPhoto = new Parse.Query(Photo);
	//Make a request using the user's objectID 
	var photoArrayOfUser = []
	queryPhoto.equalTo("userName", request.params.userName);
		queryPhoto.find
			({
			success: function(photoResult)
			{
				for(var x = 0; photoResult.length > x; x++)
				{
	                 var photoUser = photoResult[x];
	                 photoArrayOfUser.push(photoUser); 
				}
				response.success(photoArrayOfUser);
	        },
	     	error: function(error){
	        	response.error(error);
	        }

	});
});

Parse.Cloud.define("Video", function(request, response)
{
  Parse.Cloud.useMasterKey();  
  var Video = Parse.Object.extend("Video");
  //var User = Parse.Object.extend("User");
  var queryVideo = new Parse.Query(Video);
  //Make a request using the user's objectID 
  var videoArrayOfUser = []
  queryVideo.equalTo("userName", request.params.userName);
    queryVideo.find
      ({
      success: function(videoResult)
      {
        for(var x = 0; videoResult.length > x; x++)
        {
                   var videoUser = videoResult[x];
                   videoArrayOfUser.push(videoUser); 
        }
        response.success(videoArrayOfUser);
          },
        error: function(error){
            response.error(error);
          }

  });
});

Parse.Cloud.define("Note", function(request, response)
{
  var Note = Parse.Object.extend("Note");
  //var User = Parse.Object.extend("User");
  var queryNote = new Parse.Query(Note);
  //Make a request using the user's objectID 
  var noteArrayOfUser = []
  queryNote.equalTo("userName", request.params.userName);
    queryNote.find
      ({
      success: function(noteResult)
      {
        for(var x = 0; noteResult.length > x; x++)
        {
                   var noteUser = noteResult[x];
                   noteArrayOfUser.push(noteUser); 
        }
        response.success(noteArrayOfUser);
          },
        error: function(error){
            response.error(error);
          }

  });
});

Parse.Cloud.define("Link", function(request, response)
{
  var Link = Parse.Object.extend("Link");
  //var User = Parse.Object.extend("User");
  var queryLink = new Parse.Query("Link");
  //Make a request using the user's objectID 
  var linkArrayOfUser = []
  queryLink.equalTo("userName", request.params.userName);
    queryLink.find
      ({
      success: function(linkResult)
      {
        for(var x = 0; linkResult.length > x; x++)
        {
                   var linkUser = linkResult[x];
                   linkArrayOfUser.push(linkUser); 
        }
        response.success(linkArrayOfUser);
          },
        error: function(error){
            response.error(error);
          }

  });
});

// Parse.Cloud.define("Photo", 
//   function(request,response)
// {
//     var Photo = Parse.Object.extend("Photo");
//     var query = new Parse.query(Photo);
//       query.equalTo("userName", request.params.userName);
//       query.include("user");


//         query.find
//         ({
//           success: function(photos) 
//           {
//             for (var x = 0; x < photos.length; x++)
//             {
//               var photo = photos[x];
//               var user = photo.get("user");
//               console.log(user.get("objectId"));
//             }
          
//           response.success(user);
//         },
//         error: function(error) {
//           alert(error);
//         }
//   });
// });





//Problem: Getting a list of user's friends 
//In a user table 
//You'd be using the same table you already have your current logged in user ID, you'd essentially be creaing the id wouldnt
//be request params... Instead of query activity you'd be query users and then it'd be parse.query user. 
 // Parse.Cloud.define("Followers", function(request, response){   
 //    var User = Parse.Object.extend("User");
 //    var queryUserFollowers = new Parse.Query(User);
 //    var user = new User(); 
 //    user.id = request.params.currentUserID; //(whatever the current user id)
 //        queryUserFollowers.equalTo("followers", user);
 //                queryUserFollowers.find({
 //                    success: function(followers){
 //                    response.success
 //                },
 //                error: function(error) {
 //                    response.error(error);
 //                }
 //            });


