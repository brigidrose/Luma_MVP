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
                          var notificationType = ""
                          var locked = request.object.get("locked");
                          var unlockLocation = request.object.get("unlockLocation");
                          var unlockDate = request.object.get("unlockDate");
                          if (locked == true) {
                          console.log("moment is locked");
                              if (unlockDate == null){
                                  notificationType = "newLocationLockedMoment";
                              }
                              else{
                                  notificationType = "newTimeLockedMoment";
                              }
                          } else {
                          notificationType = "newMoment"
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
                                                          var pushText = author.get("firstName") + " " + author.get("lastName") + " added a moment to " + stream.get("title") + ".";
                                                          var participantsRelation = stream.relation("participants");
                                                          console.log(participantsRelation);
                                                          participantsRelation.query().find({
                                                                                            success: function (foundParticipants) {
                                                                                                for (i = 0; i < foundParticipants.length; i += 1) {
                                                                                                    if (foundParticipants[i] != request.user) {
                                                                                                    // send notification to non-self participant in stream for new moment
                                                                                            console.log("new moment notif sent to " + foundParticipants[i].get("firstName"));
                                                                                                    var pushQuery = new Parse.Query(Parse.Installation);
                                                                                                    pushQuery.equalTo("currentUser", foundParticipants[i]);
                                                                                                    pushQuery.notEqualTo("currentUser", request.user);
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
                                                                                                if (author.id != request.user.id) {
                                                                                            console.log("new moment notif sent to " + author.get("firstName"));
                                                                                                    var pushQuery = new Parse.Query(Parse.Installation);
                                                                                                    pushQuery.equalTo("currentUser", author);
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
                          }
                      });

Parse.Cloud.afterSave("Comment", function (request) {
                      var author = null;
                      var stream = null;
                      var moment = null;
                      var authorReference = request.object.get("author");
                      var momentReference = request.object.get("inMoment");
                      
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
                                                          var pushText = author.get("firstName") + " " + author.get("lastName") + " commented in " + moment.get("narrative") + " in " + stream.get("title") + ".";
                                                          var participantsRelation = stream.relation("participants");
                                                          participantsRelation.query().find({
                                                                success: function (foundParticipants) {
                                                                for (i = 0; i < foundParticipants.length; i += 1) {
                                                                if (foundParticipants[i] != request.user) {
                                                                console.log("new comment notif sent to " + foundParticipants[i].get("firstName"));
                                                                // send notification to non-self participant in stream for new moment
                                                                var pushQuery = new Parse.Query(Parse.Installation);
                                                                pushQuery.equalTo("currentUser", foundParticipants[i]);
                                                                pushQuery.notEqualTo("currentUser", request.user);
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
                                                                if (author.id != request.user.id) {
                                                                console.log("new comment notif sent to " + author.get("firstName"));
                                                                var pushQuery = new Parse.Query(Parse.Installation);
                                                                pushQuery.equalTo("currentUser", author);
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