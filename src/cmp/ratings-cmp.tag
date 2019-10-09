<ratings-cmp class="float-right">
        {ratingVal}

    <virtual if="{rated}" each="{rating,i in ratings}">
        <span class="float-left">
            <!-- {(hasFraction && (i+1 == nextInt) )? 'text-warning half-star':''} -->
            <i class="fa {getStarClass(i)}"></i>
        </span>
    </virtual>
    
    <script>
        var self = this;
        self.rated = false

        self.getStarClass = function (index) {
            if (self.hasFraction && (index == self.intRatingVal)) {
                return 'fa-star-half-o text-warning'
            } else if (index < self.intRatingVal) {
                return 'fa-star text-warning'
            } else {
                return 'fa-star text-muted'
            }
        }

        self.on('mount', function (params) {
            if (self.opts.rating) {
                var ratingVal = self.opts.rating;
                self.ratingVal = ratingVal
                var intRatingVal = parseInt(ratingVal)
                self.intRatingVal = intRatingVal
                self.hasFraction = (ratingVal - intRatingVal > 0) ? true : false;

                self.ratings = new Array(5)
                self.rated = true
                self.update();
            }

        })
    </script>
</ratings-cmp>