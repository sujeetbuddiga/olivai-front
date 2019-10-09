require("../cmp/search-result-list.cmp.tag")
require("../cmp/map-cmp.tag")
require("../cmp/restaurant-detail.cmp.tag")
<app>
  <router>
    <route path="/">
      <div class="container-fluid  pt-5">
          <div class="row">
            <div class="col-sm-4 overflow-auto" data-is="search-result-list">
              <!-- <search-result-list></search-result-list> -->
            </div>
            <div class="col-sm-8" data-is="map-cmp" searched=false>
              One of three columns
            </div>
  
          </div>
        </div>
    </route>
    <route path="/search..">
      <div class="container-fluid  pt-5">
          <div class="row">
            <div class="col-sm-4 overflow-auto" data-is="search-result-list"  searched=true>
              <!-- <search-result-list></search-result-list> -->
            </div>
            <div class="col-sm-8" data-is="map-cmp" searched=true>
              One of three columns
            </div>
  
          </div>
        </div>
    </route>
    <route path="/detail/*">
      <restaurant-detail></restaurant-detail>
    </route>
  </router>
</app>