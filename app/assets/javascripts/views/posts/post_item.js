Corky.Views.PostItemView = Backbone.View.extend({
  template: JST['posts/show'],
  className: 'item',

  render: function(){
    var content = this.template({post: this.model});
    this.$el.html(content);
    return this;
  }

})
