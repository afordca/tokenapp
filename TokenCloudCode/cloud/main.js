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
// });


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
                    followingUsersActivities[followingUser.id] = []; 
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


