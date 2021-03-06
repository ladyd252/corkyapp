Corky.Models.Event = Backbone.Model.extend({
  urlRoot: "/api/events",

  posts: function(){
    if(!this._posts){
      this._posts = new Corky.Collections.Posts([], {event: this});
    }
    return this._posts;
  },

  parse: function(response){
    if(response.posts){
      this.posts().set(response.posts, {parse: true});
      delete response.posts;
    }
    return response;
  }


});
