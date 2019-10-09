var riot = require('riot');
var route = require('riot-route/tag');
var sharedObservable = riot.observable();
route.parser(null, function (path, filter) {
    var f = filter
      .replace(/\?/g, '\\?')
      .replace(/\*/g, '([^/?#]+?)')
      .replace(/\.\./, '.*');
  
    var re = new RegExp(("^" + f + "$"));
    var args = path.match(re);
  
    if (args) {
      var value = args.slice(1)
      if (value.length) return value
      else {
        var uri = args[0].split('?')
        return uri[0].split('/')
      }
    }
  })
  

// route.parser(null, function (path, filter) {
//     var f = filter
//         .replace(/\?/g, '\\?')
//         .replace(/\*/g, '([^/?#]+?)')
//         .replace(/\.\./, '.*');

//     var re = new RegExp(("^" + f + "$"));
//     var args = path.match(re);

//     if (args) {
//         var value = args.slice(1)
//         if (value.length) return value
//         else {
//             var uri = args[0].split('?')
//             return uri[0].split('/')
//         }
//     }
// })
var registerMountedComponentsMixin = {
    init: function () {
        // this.globalObj = globalObj;
        this.route = route;
        this.on('route', function (currentNode) {
            var self = this;
            this.route = route;
            var query = self.route.query()
        })
    },
    getSharedObservable: function (params) {
        return sharedObservable;
    }


}
riot.mixin(registerMountedComponentsMixin);

module.exports = riot;