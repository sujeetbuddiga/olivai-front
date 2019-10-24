require("./search-result-compact-card.cmp.tag")
<search-result-list>
    <ul class="list-unstyled" ref="scrollItems">
        <virtual each="{item, i in items}">
            <li class="media border p-2 item--{i} search-result-item" data-is="search-result-compact-card"
                data="{item}"></li>
        </virtual>
    </ul>
    <script>
        var self = this;
        self.items = []
        self.addScroll = function () {
            let sum = 0;
            let mt5 = false
            if (self.refs.scrollItems.children.length > 5) {
                $(self.refs.scrollItems.children).each(function (index) {
                    if (index <= 5) {
                        sum += $(this).height();
                    }
                });
                $(self.refs.scrollItems).css({
                    "overflow-y": "scroll",
                    "max-height": sum + 'px'
                })
            } else {
                $(self.refs.scrollItems).removeClass({
                    "overflow-y": "scroll",
                    "max-height": sum + 'px'
                })
            }


        }

        self.on('route', function () {
            if (self.opts.searched) {
                var data = self.route.query()
                self.getSharedObservable().trigger('location-updated', data);
            }
        })
        self.getSharedObservable().on('location-updated', function (data) {
            let lat = data.lat;
            let lng = data.lng;
            var settings = {
                "url": "http://localhost:8080/https://api.yelp.com/v3/businesses/search?latitude=" + lat +
                    "&longitude=" + lng,
                "method": "GET",
                "headers": {}
            }

            $.ajax(settings).done(function (response) {
                var data = response['businesses'];
                self.items = data;
                self.update();
                self.setDataGlobal('businesses',data)
                self.getSharedObservable().trigger('data-updated');
            });
        })
        self.on('mount', function (params) {
            self.items = new Array(5);
            self.update()
        })
        self.on('updated', function (params) {
            self.addScroll()
        })
    </script>
</search-result-list>