class Promotion {
  String title;
  String image_url;
  String description;
  String contact_info;

  //{id: 231, title: Sell plumber service in Toronto, description: more details, type: 1, category_id: 3, image_url: https://www.tlcplumbinginc.com/wp-content/themes/tlc-plumbing/dist/images/plumbing-overview-540px.jpg, contact_infor: 9484346408, latitude: 44.6, longitude: -63.5}

  Promotion(String title, String image_url,String description,String contact_info) {
    this.title = title;
    this.image_url = image_url;
    this.description = description;
    this.contact_info = contact_info;
  }
}
