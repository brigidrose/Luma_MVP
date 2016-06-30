// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.afterSave("Moment", function (request) {
                      if (request.object.existed() == false){
                          var narrative = "";
                          var author = null;
                          var stream = null;
                          var momentId = request.object.id;
                          console.log(momentId);
                          var authorReference = request.object.get("author");
                          var streamReference = request.object.get("inStream");
                          var streamAuthor = null
                          var notificationType = ""
                          var locked = request.object.get("locked");
                          var unlockLocation = request.object.get("unlockLocation");
                          var unlockDate = request.object.get("unlockDate");
                          notificationType = "newMoment"
                          if (locked == true) {
                          console.log("moment is locked");
                              if (unlockDate == null){
                                  notificationType = "newLocationLockedMoment";
                              }
                              else{
                                  notificationType = "newTimeLockedMoment";
                              }
                          }
                          narrative = request.object.get("narrative");
                          var authorQuery = new Parse.Query("_User");
                          authorQuery.get(authorReference.id, {
                                          success: function (foundAuthor) {
                                          author = foundAuthor;
                                          var streamQuery = new Parse.Query("Stream");
                                          streamQuery.include("author");
                                          streamQuery.get(streamReference.id, {
                                                          success: function (foundStream) {
                                                          stream = foundStream;
                                                          streamAuthor = foundStream.get("author");
                                                          var pushText = author.get("firstName") + " " + author.get("lastName") + " added a moment to " + stream.get("title");
                                                          if (notificationType == "newLocationLockedMoment"){
                                                          pushText += ("to be unlocked near latitude: " + unlockLocation.latitude + ", longitude: " + unlockLocation.longitude);
                                                          }
                                                          if (notificationType == "newTimeLockedMoment"){
                                                          pushText += ("to be unlocked on " + unlockDate.toLocaleString());
                                                          }
                                                          var participantsRelation = stream.relation("participants");
                                                          console.log(participantsRelation);
                                                          participantsRelation.query().find({
                                                                                            success: function (foundParticipants) {
                                                                                                for (i = 0; i < foundParticipants.length; i += 1) {
                                                                                                    if (foundParticipants[i].id != request.user.id) {
                                                                                                    // send notification to non-self participant in stream for new moment
                                                                                            console.log("new moment notif sent to " + foundParticipants[i].get("firstName"));
                                                                                                    var pushQuery = new Parse.Query(Parse.Installation);
                                                                                                    pushQuery.equalTo("currentUser", foundParticipants[i]);
                                                                                                    Parse.Push.send({
                                                                                                                    where: pushQuery, // Set our Installation query
                                                                                                                    data: {
                                                                                                                    alert: pushText,
                                                                                                                    sound: "",
                                                                                                                    subtitle: "",
                                                                                                                    title: "",
                                                                                                                    "content-available": "1",
                                                                                                                    "notificationType": notificationType,
                                                                                                                    "momentObjectId": request.object.id
                                                                                                                    }
                                                                                                                    }, {
                                                                                                                    success: function () {
                                                                                                                    // Push was successful
                                                                                                                    console.log("push was successful with text: " + pushText);
                                                                                                                    },
                                                                                                                    error: function (error) {
                                                                                                                    throw "Got an error " + error.code + " : " + error.message;
                                                                                                                    }
                                                                                                                    });
                                                                                                    }
                                                                                                }
                                                                                                if (streamAuthor.id != request.user.id) {
                                                                                            console.log("new moment notif sent to " + author.get("firstName"));
                                                                                                    var pushQuery = new Parse.Query(Parse.Installation);
                                                                                                    pushQuery.equalTo("currentUser", streamAuthor);
                                                                                                    Parse.Push.send({
                                                                                                                    where: pushQuery, // Set our Installation query
                                                                                                                    data: {
                                                                                                                    alert: pushText,
                                                                                                                    sound: "",
                                                                                                                    subtitle: "",
                                                                                                                    title: "",
                                                                                                                    "content-available": "1",
                                                                                                                    "notificationType": notificationType,
                                                                                                                    "momentObjectId": request.object.id
                                                                                                                    }
                                                                                                                    }, {
                                                                                                                    success: function () {
                                                                                                                    // Push was successful
                                                                                                                    console.log("push was successful with text: " + pushText);
                                                                                                                    },
                                                                                                                    error: function (error) {
                                                                                                                    throw "Got an error " + error.code + " : " + error.message;
                                                                                                                    }
                                                                                                                    });
                                                                                                }
                                                                                            },
                                                                                            error: function (error) {
                                                                                                console.log(error);
                                                                                            }
                                                                                    });
                                                          }
                                                      }
                                                  );
                                          
                                              }
                                          });
                          }
                      });

Parse.Cloud.afterSave("Comment", function (request) {
                      var author = null;
                      var stream = null;
                      var moment = null;
                      var authorReference = request.object.get("author");
                      var momentReference = request.object.get("inMoment");
                      var streamAuthor = null;
                      var authorQuery = new Parse.Query("_User");
                      authorQuery.get(authorReference.id, {
                                      success: function (foundAuthor) {
                                          author = foundAuthor;
                                          var momentQuery = new Parse.Query("Moment");
                                          momentQuery.get(momentReference.id, {
                                                  success: function (foundMoment) {
                                                  moment = foundMoment;
                                                  var streamReference = moment.get("inStream");
                                                  var streamQuery = new Parse.Query("Stream");
                                                  streamQuery.include("author");
                                                  streamQuery.get(streamReference.id, {
                                                          success: function (foundStream) {
                                                          stream = foundStream;
                                                          streamAuthor = stream.get("author");
                                                          var pushText = author.get("firstName") + " " + author.get("lastName") + " commented in " + moment.get("narrative") + " in " + stream.get("title") + ".";
                                                          var participantsRelation = stream.relation("participants");
                                                          participantsRelation.query().find({
                                                                success: function (foundParticipants) {
                                                                for (i = 0; i < foundParticipants.length; i += 1) {
                                                                if (foundParticipants[i].id != request.user.id) {
                                                                console.log("new comment notif sent to " + foundParticipants[i].get("firstName"));
                                                                // send notification to non-self participant in stream for new moment
                                                                var pushQuery = new Parse.Query(Parse.Installation);
                                                                pushQuery.equalTo("currentUser", foundParticipants[i]);
                                                                Parse.Push.send({
                                                                                where: pushQuery, // Set our Installation query
                                                                                data: {
                                                                                alert: pushText,
                                                                                sound: "",
                                                                                subtitle: "",
                                                                                title: "",
                                                                                "content-available": "1",
                                                                                "notificationType": "newComment",
                                                                                "momentObjectId": moment.id
                                                                                }
                                                                                }, {
                                                                                success: function () {
                                                                                // Push was successful
                                                                                console.log("push was successful with text: " + pushText);
                                                                                },
                                                                                error: function (error) {
                                                                                throw "Got an error " + error.code + " : " + error.message;
                                                                                }
                                                                                });
                                                                }
                                                                }
                                                                if (streamAuthor.id != request.user.id) {
                                                                console.log("new comment notif sent to " + author.get("firstName"));
                                                                var pushQuery = new Parse.Query(Parse.Installation);
                                                                pushQuery.equalTo("currentUser", streamAuthor);
                                                                Parse.Push.send({
                                                                                where: pushQuery, // Set our Installation query
                                                                                data: {
                                                                                alert: pushText,
                                                                                sound: "",
                                                                                subtitle: "",
                                                                                title: "",
                                                                                "content-available": "1",
                                                                                "notificationType": "newMoment",
                                                                                "momentObjectId": moment.id
                                                                                }
                                                                                }, {
                                                                                success: function () {
                                                                                // Push was successful
                                                                                console.log("push was successful with text: " + pushText);
                                                                                },
                                                                                error: function (error) {
                                                                                throw "Got an error " + error.code + " : " + error.message;
                                                                                }
                                                                                });
                                                                }
                                                                },
                                                                error: function (error) {
                                                                    console.log(error);
                                                                }
                                                                });
                                                          }
                                                          }
                                                          );
                                                  
                                                  },
                                                  error: function (error) {
                                                      console.log(error);
                                                  }
                                                  });
                                      
                                          },
                                          error: function (error) {
                                              console.log(error);
                                          }
                                          });
                          
                      });

Parse.Cloud.define("sendAddedAsParticipantNotif", function(request, response) {
                   var senderUser = request.user;
                   var recipientUserId = request.params.recipientId;
                   var message = request.params.message;
                   
                   
                   // Send the push.
                   // Find devices associated with the recipient user
                   var recipientUser = new Parse.User();
                   recipientUser.id = recipientUserId;
                   var pushQuery = new Parse.Query(Parse.Installation);
                   pushQuery.equalTo("currentUser", recipientUser);
                   
                   // Send the push notification to results of the query
                   Parse.Push.send({
                                   where: pushQuery,
                                   data: {
                                   alert: message,
                                   "content-available": "1",
                                   "notificationType": "addedAsParticipant"
                                   }
                                   }).then(function() {
                                           response.success("Push was sent successfully.")
                                           }, function(error) {
                                           response.error("Push failed to send with error: " + error.message);
                                           });
                   });
