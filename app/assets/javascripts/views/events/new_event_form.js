Corky.Views.NewEventFormView= Backbone.View.extend({
  template: JST["events/new_event_form"],
  className: "tab-pane active",
  id: "new",

  events:{
    "submit .event-form" : "addEvent"
  },

  addEvent: function(event){
    event.preventDefault();
    var params = $(event.target).serializeJSON();
    var newEvent = new Corky.Models.Event();
    var collection = this.collection;
    var that = this;
    newEvent.save(params, {
      success: function(){
        collection.add(newEvent);
        Backbone.history.navigate("events/" + newEvent.id, {trigger: true})
      }
      // error do something with form
    })
  },

  render: function(){
    var content = this.template();
    this.$el.html(content);
    return this;
  },

})
