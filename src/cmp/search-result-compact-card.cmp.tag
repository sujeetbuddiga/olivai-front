require("./ratings-cmp.tag")
<search-result-compact-card>
    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-10">
                    <p>
                        <a class="float-left" href="#/detail/{data.id}"><strong>{data.name}</strong></a>
                        <ratings-cmp rating={data.rating}></ratings-cmp>
                    </p>
                    <div class="clearfix"></div>

                </div>
                <div class="col-md-2"> <img src={data.image_url} class="img img-rounded img-fluid">
                </div>
            </div>
        </div>
    </div>
    <script>
        var self = this;
        self.data = {}
        self.data.name = ''
        self.data.rating = ''

        self.on('mount', function (params) {
            if (self.opts.data) {
                self.data = self.opts.data;
                self.update()
            }

        })
    </script>
</search-result-compact-card>