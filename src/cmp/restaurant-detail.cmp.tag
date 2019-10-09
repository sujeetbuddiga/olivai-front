<restaurant-detail>
    <div class="container m-5">
        <div class="jumbotron jumbotron-fluid jumbotronImg" style="{bgImg()}">
            <div class="container">
                <h1 class="display-4">{data.name}</h1>
                <p class="lead">{data.alias}.
                </p>
            </div>
        </div>
        <table class="table-striped table table-sm table-hover table-responsive">
            <tbody>
                <tr>
                    <th scope="row">is_claimed</th>
                    <td>{data.is_claimed}</td>
                </tr>
                <tr>
                    <th scope="row">Is Closed</th>
                    <td>{data.is_closed}</td>
                </tr>
                <tr>
                    <th scope="row">yelp</th>
                    <td>{data.url}</td>
                </tr>
                <tr>
                    <th scope="row">phone</th>
                    <td>{data.phone}</td>
                </tr>
                <tr>
                    <th scope="row">review_count</th>
                    <td>{data.review_count}</td>
                </tr>
                <tr>
                    <th scope="row">rating</th>
                    <td>{data.rating}</td>
                </tr>
                <tr>
                    <th scope="row">price</th>
                    <td>{data.price}</td>
                </tr>
                <tr>
                    <th scope="row">rating</th>
                    <td>{data.rating}</td>
                </tr>
               
            </tbody>
        </table>
    </div>
    <script>
        var self = this;
        self.data = {}
        self.data.image_url = ""
        self.bgImg = function () {
            return "background: url(" + self.data.image_url + ");" +
                "background-repeat: no-repeat;" +
                "background-size: cover;"
        }
        self.on('route', function (id) {
            var settings = {
                "url": "http://localhost:8080/https://api.yelp.com/v3/businesses/" + id,
                "method": "GET",
            }

            $.ajax(settings).done(function (response) {
                console.log(response);
                self.data = response
                self.update()
            });
        })
    </script>

</restaurant-detail>