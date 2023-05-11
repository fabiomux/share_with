# frozen_string_literal: true

TWITTER_ICON = '<a href="https://twitter.com/share?text=&url=https%3A%2F%2Ffreeaptitude
.altervista.org%2Fprojects%2Fshare-with.html&related=&hashtags=" title="Share with Twitter" class=
"share-with-twitter"><img src="https://cdnjs.cloudflare.com/ajax/libs/simple-icons/8.6.0/twitter.svg"
 alt="Share with Twitter" width="48" height="48" /></a>'

FACEBOOK_ICON = '<a href="https://www.facebook.com/sharer.php?u=https%3A%2F%2Ffreeaptitude
.altervista.org%2Fprojects%2Fshare-with.html&t=" title="Share with Facebook" class=
"share-with-facebook"><img src="https://cdnjs.cloudflare.com/ajax/libs/simple-icons/8.6.0/facebook.svg"
 alt="Share with Facebook" width="48" height="48" /></a>'

RSpec.describe ShareWith::Collection do
  before(:all) do
    @collection = ShareWith::Collection.new(services: ["twitter"])
  end

  describe "Initialization" do
    context "Adding services" do
      it "initializes a collection" do
        expect(@collection.services.key?(:twitter)).to eq(true)
      end

      it "adds a service to the collection" do
        @collection.create_or_reset("facebook")
        expect(@collection.services.key?(:facebook)).to eq(true)
      end
    end
  end

  describe "Rendering" do
    context "Icon template" do
      it "renders a service" do
        @collection.set_value_to_all("url", "https://freeaptitude.altervista.org/projects/share-with.html")
        expect(@collection.render("twitter", "icon")).to eq(TWITTER_ICON.gsub(/\n/, ""))
      end

      it "renders all the loaded services" do
        res = { facebook: FACEBOOK_ICON.gsub(/\n/, ""), twitter: TWITTER_ICON.gsub(/\n/, "") }
        expect(@collection.render_all("icon")).to eq(res)
      end
    end
  end
end
